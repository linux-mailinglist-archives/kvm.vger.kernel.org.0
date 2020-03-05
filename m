Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D5917A911
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgCEPlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:41:46 -0500
Received: from foss.arm.com ([217.140.110.172]:50158 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgCEPlq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:41:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDA9130E;
        Thu,  5 Mar 2020 07:41:45 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B90153F534;
        Thu,  5 Mar 2020 07:41:44 -0800 (PST)
Subject: Re: [PATCH v2 kvmtool 10/30] virtio/pci: Make memory and IO BARs
 independent
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-11-alexandru.elisei@arm.com>
 <20200129181638.6cbfc8f1@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7a753efb-9344-752a-a005-c6939ef1a76c@arm.com>
Date:   Thu, 5 Mar 2020 15:41:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200129181638.6cbfc8f1@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/29/20 6:16 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:45 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> Currently, callbacks for memory BAR 1 call the IO port emulation.  This
>> means that the memory BAR needs I/O Space to be enabled whenever Memory
>> Space is enabled.
>>
>> Refactor the code so the two type of  BARs are independent. Also, unify
>> ioport/mmio callback arguments so that they all receive a virtio_device.
> That's a nice cleanup, I like that it avoids shoehorning everything as legacy I/O into the emulation.
>
> Just a nit below, but nevertheless:
>  
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thank you!

[..]

>
>> +static bool virtio_pci__io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>> +{
>> +	unsigned long offset;
>> +	struct virtio_device *vdev;
>> +	struct virtio_pci *vpci;
>> +
>> +	vdev = ioport->priv;
>> +	vpci = vdev->virtio;
>> +	offset = port - vpci->port_addr;
> You could initialise the variables directly at their declaration, which looks nicer and underlines that they are just helper variables.
> Same below.

Sure, makes sense. I'll make the change for virtio_pci__io_{in,out}.

Thanks, Alex

>
> Cheers,
> Andre.
>
>> +
>> +	return virtio_pci__data_in(vcpu, vdev, offset, data, size);
>> +}
>> +
>>  static void update_msix_map(struct virtio_pci *vpci,
>>  			    struct msix_table *msix_entry, u32 vecnum)
>>  {
>> @@ -185,8 +195,8 @@ static void update_msix_map(struct virtio_pci *vpci,
>>  	irq__update_msix_route(vpci->kvm, gsi, &msix_entry->msg);
>>  }
>>  
>> -static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *vdev, u16 port,
>> -					void *data, int size, int offset)
>> +static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device *vdev,
>> +					  void *data, int size, unsigned long offset)
>>  {
>>  	struct virtio_pci *vpci = vdev->virtio;
>>  	u32 config_offset, vec;
>> @@ -259,19 +269,16 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
>>  	return false;
>>  }
>>  
>> -static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>> +static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vdev,
>> +				 unsigned long offset, void *data, int size)
>>  {
>> -	unsigned long offset;
>>  	bool ret = true;
>> -	struct virtio_device *vdev;
>>  	struct virtio_pci *vpci;
>>  	struct kvm *kvm;
>>  	u32 val;
>>  
>>  	kvm = vcpu->kvm;
>> -	vdev = ioport->priv;
>>  	vpci = vdev->virtio;
>> -	offset = port - vpci->port_addr;
>>  
>>  	switch (offset) {
>>  	case VIRTIO_PCI_GUEST_FEATURES:
>> @@ -304,13 +311,26 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16
>>  		virtio_notify_status(kvm, vdev, vpci->dev, vpci->status);
>>  		break;
>>  	default:
>> -		ret = virtio_pci__specific_io_out(kvm, vdev, port, data, size, offset);
>> +		ret = virtio_pci__specific_data_out(kvm, vdev, data, size, offset);
>>  		break;
>>  	};
>>  
>>  	return ret;
>>  }
>>  
>> +static bool virtio_pci__io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>> +{
>> +	unsigned long offset;
>> +	struct virtio_device *vdev;
>> +	struct virtio_pci *vpci;
>> +
>> +	vdev = ioport->priv;
>> +	vpci = vdev->virtio;
>> +	offset = port - vpci->port_addr;
>> +
>> +	return virtio_pci__data_out(vcpu, vdev, offset, data, size);
>> +}
>> +
>>  static struct ioport_operations virtio_pci__io_ops = {
>>  	.io_in	= virtio_pci__io_in,
>>  	.io_out	= virtio_pci__io_out,
>> @@ -320,7 +340,8 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
>>  					   u64 addr, u8 *data, u32 len,
>>  					   u8 is_write, void *ptr)
>>  {
>> -	struct virtio_pci *vpci = ptr;
>> +	struct virtio_device *vdev = ptr;
>> +	struct virtio_pci *vpci = vdev->virtio;
>>  	struct msix_table *table;
>>  	int vecnum;
>>  	size_t offset;
>> @@ -419,11 +440,15 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>>  					 u64 addr, u8 *data, u32 len,
>>  					 u8 is_write, void *ptr)
>>  {
>> -	struct virtio_pci *vpci = ptr;
>> -	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
>> -	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
>> +	struct virtio_device *vdev = ptr;
>> +	struct virtio_pci *vpci = vdev->virtio;
>>  
>> -	kvm__emulate_io(vcpu, port, data, direction, len, 1);
>> +	if (!is_write)
>> +		virtio_pci__data_in(vcpu, vdev, addr - vpci->mmio_addr,
>> +				    data, len);
>> +	else
>> +		virtio_pci__data_out(vcpu, vdev, addr - vpci->mmio_addr,
>> +				     data, len);
>>  }
>>  
>>  int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>> @@ -445,13 +470,13 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>>  
>>  	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
>>  	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
>> -			       virtio_pci__io_mmio_callback, vpci);
>> +			       virtio_pci__io_mmio_callback, vdev);
>>  	if (r < 0)
>>  		goto free_ioport;
>>  
>>  	vpci->msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
>>  	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
>> -			       virtio_pci__msix_mmio_callback, vpci);
>> +			       virtio_pci__msix_mmio_callback, vdev);
>>  	if (r < 0)
>>  		goto free_mmio;
>>  
