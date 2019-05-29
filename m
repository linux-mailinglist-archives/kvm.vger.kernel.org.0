Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E56582E023
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 16:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfE2Out (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 10:50:49 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47392 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfE2Ous (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 10:50:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 348F7341;
        Wed, 29 May 2019 07:50:48 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E6693F5AF;
        Wed, 29 May 2019 07:50:47 -0700 (PDT)
Subject: Re: [PATCH kvmtool 3/4] vfio: rework vfio_irq_set payload setting
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20190503171544.260901-1-andre.przywara@arm.com>
 <20190503171544.260901-4-andre.przywara@arm.com>
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <769d72ee-192d-af55-c44f-dc51953bb71d@arm.com>
Date:   Wed, 29 May 2019 15:50:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190503171544.260901-4-andre.przywara@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 18:15, Andre Przywara wrote:
> struct vfio_irq_set from the kernel headers contains a variable sized
> array to hold a payload. The vfio_irq_eventfd struct puts the "fd"
> member right after this, hoping it to automatically fit in the payload slot.
> But having a variable sized type not at the end of a struct is a GNU C
> extension, so clang will refuse to compile this.
> 
> Solve this by somewhat doing the compiler's job and place the payload
> manually at the end of the structure.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

It's odd that clang still warns about it even when passing -std=gnuXX.
The resulting code doesn't look particularly nice, but it would be good
to have the other patches upstream and this one is harmless, so:

Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

> ---
>  vfio/pci.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index a4086326..76e24c15 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -9,11 +9,16 @@
>  #include <sys/time.h>
>  
>  /* Wrapper around UAPI vfio_irq_set */
> -struct vfio_irq_eventfd {
> +union vfio_irq_eventfd {
>  	struct vfio_irq_set	irq;
> -	int			fd;
> +	u8 buffer[sizeof(struct vfio_irq_set) + sizeof(int)];
>  };
>  
> +static void set_vfio_irq_eventd_payload(union vfio_irq_eventfd *evfd, int fd)
> +{
> +	memcpy(&evfd->irq.data, &fd, sizeof(fd));
> +}
> +
>  #define msi_is_enabled(state)		((state) & VFIO_PCI_MSI_STATE_ENABLED)
>  #define msi_is_masked(state)		((state) & VFIO_PCI_MSI_STATE_MASKED)
>  #define msi_is_empty(state)		((state) & VFIO_PCI_MSI_STATE_EMPTY)
> @@ -38,7 +43,7 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
>  	int *eventfds;
>  	struct vfio_pci_device *pdev = &vdev->pci;
>  	struct vfio_pci_msi_common *msis = msix ? &pdev->msix : &pdev->msi;
> -	struct vfio_irq_eventfd single = {
> +	union vfio_irq_eventfd single = {
>  		.irq = {
>  			.argsz	= sizeof(single),
>  			.flags	= VFIO_IRQ_SET_DATA_EVENTFD |
> @@ -117,7 +122,7 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
>  			continue;
>  
>  		single.irq.start = i;
> -		single.fd = fd;
> +		set_vfio_irq_eventd_payload(&single, fd);
>  
>  		ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &single);
>  		if (ret < 0) {
> @@ -1021,8 +1026,8 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
>  {
>  	int ret;
>  	int trigger_fd, unmask_fd;
> -	struct vfio_irq_eventfd	trigger;
> -	struct vfio_irq_eventfd	unmask;
> +	union vfio_irq_eventfd	trigger;
> +	union vfio_irq_eventfd	unmask;
>  	struct vfio_pci_device *pdev = &vdev->pci;
>  	int gsi = pdev->intx_gsi;
>  
> @@ -1058,7 +1063,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
>  		.start	= 0,
>  		.count	= 1,
>  	};
> -	trigger.fd = trigger_fd;
> +	set_vfio_irq_eventd_payload(&trigger, trigger_fd);
>  
>  	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &trigger);
>  	if (ret < 0) {
> @@ -1073,7 +1078,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
>  		.start	= 0,
>  		.count	= 1,
>  	};
> -	unmask.fd = unmask_fd;
> +	set_vfio_irq_eventd_payload(&unmask, unmask_fd);
>  
>  	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &unmask);
>  	if (ret < 0) {
> 

