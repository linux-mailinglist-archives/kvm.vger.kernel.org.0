Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B83421279D
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgGBPUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:20:14 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:36726 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgGBPUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593703213; x=1625239213;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=2DSyT3G5NpQ5smpnj4M1a1bnoZnxRiHdgwkVgPd6dDk=;
  b=EyDWfeKbDZiYcjZ6gWEjbgNs8ElHaF7GUSqd+RM3ss9E1RbsY5fXoO1d
   ioay5Sjmg4IcPWz5QF54r32w6Ivf3RyLt7pbHzP8DoB3NRSzjf/fcUkBu
   6tnAxxycXP9qkfeqErHqhaoyqzgZO9OkEDxuZlMq3U83S4tVFCREw7Qy/
   4=;
IronPort-SDR: 4D30P/S2NtjP65v0qUQWCjceldm+qTGAfhbWEoL3Dvkszg5VyFpboXtLKRw4IwHUIa845j1xzr
 PBRLcH56O7Pg==
X-IronPort-AV: E=Sophos;i="5.75,304,1589241600"; 
   d="scan'208";a="39836329"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Jul 2020 15:20:10 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 59945120F14;
        Thu,  2 Jul 2020 15:20:09 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:20:08 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.203) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:20:00 +0000
Subject: Re: [PATCH v4 05/18] nitro_enclaves: Handle PCI device command
 requests
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
        <ne-devel-upstream@amazon.com>, kbuild test robot <lkp@intel.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-6-andraprs@amazon.com>
From:   Alexander Graf <graf@amazon.de>
Message-ID: <7a0b3e10-8760-db9c-37a3-aadbb7a042de@amazon.de>
Date:   Thu, 2 Jul 2020 17:19:57 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-6-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.203]
X-ClientProxiedBy: EX13D18UWC002.ant.amazon.com (10.43.162.88) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> The Nitro Enclaves PCI device exposes a MMIO space that this driver
> uses to submit command requests and to receive command replies e.g. for
> enclave creation / termination or setting enclave resources.
> =

> Add logic for handling PCI device command requests based on the given
> command type.
> =

> Register an MSI-X interrupt vector for command reply notifications to
> handle this type of communication events.
> =

> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> =

> Fix issue reported in:
> https://lore.kernel.org/lkml/202004231644.xTmN4Z1z%25lkp@intel.com/
> =

> Reported-by: kbuild test robot <lkp@intel.com>
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
> * Remove the BUG_ON calls.
> * Update goto labels to match their purpose.
> * Add fix for kbuild report.
> ---
>   drivers/virt/nitro_enclaves/ne_pci_dev.c | 232 +++++++++++++++++++++++
>   1 file changed, 232 insertions(+)
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitr=
o_enclaves/ne_pci_dev.c
> index 235fa3ecbee2..c24230cfe7c0 100644
> --- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -27,6 +27,218 @@ static const struct pci_device_id ne_pci_ids[] =3D {
>   =

>   MODULE_DEVICE_TABLE(pci, ne_pci_ids);
>   =

> +/**
> + * ne_submit_request - Submit command request to the PCI device based on=
 the
> + * command type.
> + *
> + * This function gets called with the ne_pci_dev mutex held.
> + *
> + * @pdev: PCI device to send the command to.
> + * @cmd_type: command type of the request sent to the PCI device.
> + * @cmd_request: command request payload.
> + * @cmd_request_size: size of the command request payload.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_submit_request(struct pci_dev *pdev,
> +			     enum ne_pci_dev_cmd_type cmd_type,
> +			     void *cmd_request, size_t cmd_request_size)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return -EINVAL;

How can this ever happen?

> +
> +	memcpy_toio(ne_pci_dev->iomem_base + NE_SEND_DATA, cmd_request,
> +		    cmd_request_size);
> +
> +	iowrite32(cmd_type, ne_pci_dev->iomem_base + NE_COMMAND);
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_retrieve_reply - Retrieve reply from the PCI device.
> + *
> + * This function gets called with the ne_pci_dev mutex held.
> + *
> + * @pdev: PCI device to receive the reply from.
> + * @cmd_reply: command reply payload.
> + * @cmd_reply_size: size of the command reply payload.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_retrieve_reply(struct pci_dev *pdev,
> +			     struct ne_pci_dev_cmd_reply *cmd_reply,
> +			     size_t cmd_reply_size)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return -EINVAL;

Same.

> +
> +	memcpy_fromio(cmd_reply, ne_pci_dev->iomem_base + NE_RECV_DATA,
> +		      cmd_reply_size);
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_wait_for_reply - Wait for a reply of a PCI command.
> + *
> + * This function gets called with the ne_pci_dev mutex held.
> + *
> + * @pdev: PCI device for which a reply is waited.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_wait_for_reply(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +	int rc =3D -EINVAL;

Unused assignment?

> +
> +	if (!ne_pci_dev)
> +		return -EINVAL;

Same.

> +
> +	/*
> +	 * TODO: Update to _interruptible and handle interrupted wait event
> +	 * e.g. -ERESTARTSYS, incoming signals + add / update timeout.
> +	 */
> +	rc =3D wait_event_timeout(ne_pci_dev->cmd_reply_wait_q,
> +				atomic_read(&ne_pci_dev->cmd_reply_avail) !=3D 0,
> +				msecs_to_jiffies(NE_DEFAULT_TIMEOUT_MSECS));
> +	if (!rc)
> +		return -ETIMEDOUT;
> +
> +	return 0;
> +}
> +
> +int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_typ=
e,
> +		  void *cmd_request, size_t cmd_request_size,
> +		  struct ne_pci_dev_cmd_reply *cmd_reply, size_t cmd_reply_size)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D NULL;
> +	int rc =3D -EINVAL;
> +
> +	if (!pdev)
> +		return -ENODEV;

When can this happen?

> +
> +	ne_pci_dev =3D pci_get_drvdata(pdev);
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return -EINVAL;

Same

> +
> +	if (cmd_type <=3D INVALID_CMD || cmd_type >=3D MAX_CMD) {
> +		dev_err_ratelimited(&pdev->dev, "Invalid cmd type=3D%u\n",
> +				    cmd_type);
> +
> +		return -EINVAL;
> +	}
> +
> +	if (!cmd_request) {
> +		dev_err_ratelimited(&pdev->dev, "Null cmd request\n");
> +
> +		return -EINVAL;
> +	}
> +
> +	if (cmd_request_size > NE_SEND_DATA_SIZE) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Invalid req size=3D%zu for cmd type=3D%u\n",
> +				    cmd_request_size, cmd_type);
> +
> +		return -EINVAL;
> +	}
> +
> +	if (!cmd_reply) {
> +		dev_err_ratelimited(&pdev->dev, "Null cmd reply\n");
> +
> +		return -EINVAL;
> +	}
> +
> +	if (cmd_reply_size > NE_RECV_DATA_SIZE) {
> +		dev_err_ratelimited(&pdev->dev, "Invalid reply size=3D%zu\n",
> +				    cmd_reply_size);
> +
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Use this mutex so that the PCI device handles one command request at
> +	 * a time.
> +	 */
> +	mutex_lock(&ne_pci_dev->pci_dev_mutex);
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
> +
> +	rc =3D ne_submit_request(pdev, cmd_type, cmd_request, cmd_request_size);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Error in submit request [rc=3D%d]\n", rc);
> +
> +		goto unlock_mutex;
> +	}
> +
> +	rc =3D ne_wait_for_reply(pdev);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Error in wait for reply [rc=3D%d]\n", rc);
> +
> +		goto unlock_mutex;
> +	}
> +
> +	rc =3D ne_retrieve_reply(pdev, cmd_reply, cmd_reply_size);
> +	if (rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Error in retrieve reply [rc=3D%d]\n", rc);
> +
> +		goto unlock_mutex;
> +	}
> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
> +
> +	if (cmd_reply->rc < 0) {
> +		dev_err_ratelimited(&pdev->dev,
> +				    "Error in cmd process logic [rc=3D%d]\n",
> +				    cmd_reply->rc);
> +
> +		rc =3D cmd_reply->rc;
> +
> +		goto unlock_mutex;
> +	}
> +
> +	mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +	return 0;

Can you just set rc to 0 and fall through?

> +
> +unlock_mutex:
> +	mutex_unlock(&ne_pci_dev->pci_dev_mutex);
> +
> +	return rc;
> +}
> +
> +/**
> + * ne_reply_handler - Interrupt handler for retrieving a reply matching
> + * a request sent to the PCI device for enclave lifetime management.
> + *
> + * @irq: received interrupt for a reply sent by the PCI device.
> + * @args: PCI device private data structure.
> + *
> + * @returns: IRQ_HANDLED on handled interrupt, IRQ_NONE otherwise.
> + */
> +static irqreturn_t ne_reply_handler(int irq, void *args)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D (struct ne_pci_dev *)args;
> +
> +	if (!ne_pci_dev)
> +		return IRQ_NONE;

How can this ever happen?


Alex

> +
> +	atomic_set(&ne_pci_dev->cmd_reply_avail, 1);
> +
> +	/* TODO: Update to _interruptible. */
> +	wake_up(&ne_pci_dev->cmd_reply_wait_q);
> +
> +	return IRQ_HANDLED;
> +}
> +
>   /**
>    * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>    *
> @@ -59,7 +271,25 @@ static int ne_setup_msix(struct pci_dev *pdev)
>   		return rc;
>   	}
>   =

> +	/*
> +	 * This IRQ gets triggered every time the PCI device responds to a
> +	 * command request. The reply is then retrieved, reading from the MMIO
> +	 * space of the PCI device.
> +	 */
> +	rc =3D request_irq(pci_irq_vector(pdev, NE_VEC_REPLY),
> +			 ne_reply_handler, 0, "enclave_cmd", ne_pci_dev);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "Error in request irq reply [rc=3D%d]\n", rc);
> +
> +		goto free_irq_vectors;
> +	}
> +
>   	return 0;
> +
> +free_irq_vectors:
> +	pci_free_irq_vectors(pdev);
> +
> +	return rc;
>   }
>   =

>   /**
> @@ -74,6 +304,8 @@ static void ne_teardown_msix(struct pci_dev *pdev)
>   	if (!ne_pci_dev)
>   		return;
>   =

> +	free_irq(pci_irq_vector(pdev, NE_VEC_REPLY), ne_pci_dev);
> +
>   	pci_free_irq_vectors(pdev);
>   }
>   =

> =




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



