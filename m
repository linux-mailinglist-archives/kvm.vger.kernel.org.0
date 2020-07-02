Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8279B2127C6
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgGBPYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:24:36 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:59508 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730214AbgGBPYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:24:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593703472; x=1625239472;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=i22HdhTJfY8wQgGxyIyoaw+4TYPhLvEg95EhNweLJkM=;
  b=W9UPK5UjYi5ESa998CWI0eA6o7FoKHMeczSU/K+Y7Ei6kwpzut2P1lZM
   H5BspqrpAB2mpNv+0r0yfvJUPlBAnymPPUogK/DXnwkILIWQW2Wt0JrB3
   KxjoDoK4xJ8geDF7WTz4553pWvTWmFZd7UMrlKD6LdjFb3ypKXT/O1AC8
   E=;
IronPort-SDR: FjgJXuOcge30lkpN0wmmU1RbRUjLXQAZjaqbnVc0TwPDPD8G0qmpZeKKCnRZPy14FBKzCGWuDy
 f8UTriT0bF7g==
X-IronPort-AV: E=Sophos;i="5.75,304,1589241600"; 
   d="scan'208";a="39699664"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 02 Jul 2020 15:24:25 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 1F1EAA06EB;
        Thu,  2 Jul 2020 15:24:25 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:24:24 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.65) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:24:17 +0000
Subject: Re: [PATCH v4 06/18] nitro_enclaves: Handle out-of-band PCI device
 events
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-7-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <82768612-0d23-55a9-dedf-58ade57b37af@amazon.de>
Date:   Thu, 2 Jul 2020 17:24:11 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-7-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.65]
X-ClientProxiedBy: EX13D16UWB001.ant.amazon.com (10.43.161.17) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> In addition to the replies sent by the Nitro Enclaves PCI device in
> response to command requests, out-of-band enclave events can happen e.g.
> an enclave crashes. In this case, the Nitro Enclaves driver needs to be
> aware of the event and notify the corresponding user space process that
> abstracts the enclave.
> =

> Register an MSI-X interrupt vector to be used for this kind of
> out-of-band events. The interrupt notifies that the state of an enclave
> changed and the driver logic scans the state of each running enclave to
> identify for which this notification is intended.
> =

> Create an workqueue to handle the out-of-band events. Notify user space
> enclave process that is using a polling mechanism on the enclave fd.
> =

> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Use dev_err instead of custom NE log pattern.
> * Return IRQ_NONE when interrupts are not handled.
> =

> v2 -> v3
> =

> * Remove the WARN_ON calls.
> * Update static calls sanity checks.
> * Remove "ratelimited" from the logs that are not in the ioctl call
>    paths.
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Update goto labels to match their purpose.
> ---
>   drivers/virt/nitro_enclaves/ne_pci_dev.c | 122 +++++++++++++++++++++++
>   1 file changed, 122 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitr=
o_enclaves/ne_pci_dev.c
> index c24230cfe7c0..9a137862cade 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -239,6 +239,93 @@ static irqreturn_t ne_reply_handler(int irq, void *a=
rgs)
>   	return IRQ_HANDLED;
>   }
>   =

> +/**
> + * ne_event_work_handler - Work queue handler for notifying enclaves on
> + * a state change received by the event interrupt handler.
> + *
> + * An out-of-band event is being issued by the Nitro Hypervisor when at =
least
> + * one enclave is changing state without client interaction.
> + *
> + * @work: item containing the Nitro Enclaves PCI device for which a
> + *	  out-of-band event was issued.
> + */
> +static void ne_event_work_handler(struct work_struct *work)
> +{
> +	struct ne_pci_dev_cmd_reply cmd_reply =3D {};
> +	struct ne_enclave *ne_enclave =3D NULL;
> +	struct ne_pci_dev *ne_pci_dev =3D
> +		container_of(work, struct ne_pci_dev, notify_work);
> +	int rc =3D -EINVAL;
> +	struct slot_info_req slot_info_req =3D {};
> +
> +	if (!ne_pci_dev)
> +		return;

How?

> +
> +	mutex_lock(&ne_pci_dev->enclaves_list_mutex);
> +
> +	/*
> +	 * Iterate over all enclaves registered for the Nitro Enclaves
> +	 * PCI device and determine for which enclave(s) the out-of-band event
> +	 * is corresponding to.
> +	 */
> +	list_for_each_entry(ne_enclave, &ne_pci_dev->enclaves_list,
> +			    enclave_list_entry) {
> +		mutex_lock(&ne_enclave->enclave_info_mutex);
> +
> +		/*
> +		 * Enclaves that were never started cannot receive out-of-band
> +		 * events.
> +		 */
> +		if (ne_enclave->state !=3D NE_STATE_RUNNING)
> +			goto unlock;
> +
> +		slot_info_req.slot_uid =3D ne_enclave->slot_uid;
> +
> +		rc =3D ne_do_request(ne_enclave->pdev, SLOT_INFO, &slot_info_req,
> +				   sizeof(slot_info_req), &cmd_reply,
> +				   sizeof(cmd_reply));
> +		if (rc < 0)
> +			dev_err(&ne_enclave->pdev->dev,
> +				"Error in slot info [rc=3D%d]\n", rc);
> +
> +		/* Notify enclave process that the enclave state changed. */
> +		if (ne_enclave->state !=3D cmd_reply.state) {
> +			ne_enclave->state =3D cmd_reply.state;
> +
> +			ne_enclave->has_event =3D true;
> +
> +			wake_up_interruptible(&ne_enclave->eventq);
> +		}
> +
> +unlock:
> +		 mutex_unlock(&ne_enclave->enclave_info_mutex);
> +	}
> +
> +	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
> +}
> +
> +/**
> + * ne_event_handler - Interrupt handler for PCI device out-of-band
> + * events. This interrupt does not supply any data in the MMIO region.
> + * It notifies a change in the state of any of the launched enclaves.
> + *
> + * @irq: received interrupt for an out-of-band event.
> + * @args: PCI device private data structure.
> + *
> + * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
> + */
> +static irqreturn_t ne_event_handler(int irq, void *args)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D (struct ne_pci_dev *)args;
> +
> +	if (!ne_pci_dev)
> +		return IRQ_NONE;

How can this happen?


Alex

> +
> +	queue_work(ne_pci_dev->event_wq, &ne_pci_dev->notify_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
>   /**
>    * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>    *
> @@ -284,8 +371,37 @@ static int ne_setup_msix(struct pci_dev *pdev)
>   		goto free_irq_vectors;
>   	}
>   =

> +	ne_pci_dev->event_wq =3D create_singlethread_workqueue("ne_pci_dev_wq");
> +	if (!ne_pci_dev->event_wq) {
> +		rc =3D -ENOMEM;
> +
> +		dev_err(&pdev->dev, "Cannot get wq for dev events [rc=3D%d]\n",
> +			rc);
> +
> +		goto free_reply_irq_vec;
> +	}
> +
> +	INIT_WORK(&ne_pci_dev->notify_work, ne_event_work_handler);
> +
> +	/*
> +	 * This IRQ gets triggered every time any enclave's state changes. Its
> +	 * handler then scans for the changes and propagates them to the user
> +	 * space.
> +	 */
> +	rc =3D request_irq(pci_irq_vector(pdev, NE_VEC_EVENT),
> +			 ne_event_handler, 0, "enclave_evt", ne_pci_dev);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "Error in request irq event [rc=3D%d]\n", rc);
> +
> +		goto destroy_wq;
> +	}
> +
>   	return 0;
>   =

> +destroy_wq:
> +	destroy_workqueue(ne_pci_dev->event_wq);
> +free_reply_irq_vec:
> +	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>   free_irq_vectors:
>   	pci_free_irq_vectors(pdev);
>   =

> @@ -304,6 +420,12 @@ static void ne_teardown_msix(struct pci_dev *pdev)
>   	if (!ne_pci_dev)
>   		return;
>   =

> +	free_irq(pci_irq_vector(pdev, NE_VEC_EVENT), ne_pci_dev);
> +
> +	flush_work(&ne_pci_dev->notify_work);
> +	flush_workqueue(ne_pci_dev->event_wq);
> +	destroy_workqueue(ne_pci_dev->event_wq);
> +
>   	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
>   =

>   	pci_free_irq_vectors(pdev);
> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



