Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9496DCD43
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 00:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDJWGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 18:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjDJWGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 18:06:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5C71BCA
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 15:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681164342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JDZhCwGo8x3+STKd4yRTec3uFmFqrpXKNILuRc0wVDM=;
        b=L2sIAFvAT2baJMBezUrXufrgAO7Gld3mBBpT7P0G43ThXFJcfKCkjnBCYHt/112M4jeJM7
        KC9roqaxIZMMwnJPUcilnXwBR1BQy/GLuKHvqWU9ncZe5AXB8qdYxlqWPd/fUeG2TB/KhZ
        ro5ll54sLtjvQGmHmXkffzhJsRhUqZs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-pjWHADIIMISeE9-6VTYBzQ-1; Mon, 10 Apr 2023 18:05:40 -0400
X-MC-Unique: pjWHADIIMISeE9-6VTYBzQ-1
Received: by mail-io1-f69.google.com with SMTP id m22-20020a0566022e9600b007608fe7d67dso856028iow.8
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 15:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681164340; x=1683756340;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JDZhCwGo8x3+STKd4yRTec3uFmFqrpXKNILuRc0wVDM=;
        b=akKNxqzlcQw9QvQ31WgZhObT4bTA30skT3eCGQSjN/fSUBq8eOTAeOmLI0m6voTy8I
         fyiHHAkwpV6H7MMqX1sObPGZDzfibVabr/z6NcSzmkt7BthWwnf17iQnSmhS76Ill14g
         Ph/LSX/VgD3EfVUITxokb0w6nKPPR1YgTc96qBnC40j4kw/g23KuNxNhoK7+xYh7Ylp3
         USLvxgC+iv6tOZ9w5yS0yKYbmhd10v3CsG0PqVYY0Kl9NfuGQMJ6nU9z8ICCCSJ7gXKB
         Y2u71dpzlPAmIouK8XNrO/uJSdXPOS24AHV/cTyYqizwiNd3ZjcJmr6SOvzR8rQUsatK
         uU2g==
X-Gm-Message-State: AAQBX9fe95lAa1HQT5mIHEaS4jzdjkzTqBiPvJ+d9k0e2tQxXpp2ur8N
        4KMD0k3fV2T1k4T7ft9vL48DCZjOFMqMylJa550q3dbhCGeiJmzt05DYYkuXAf/sOSvlNXs9lAX
        HjUO4R2+/wjYo
X-Received: by 2002:a92:c501:0:b0:325:b96e:6709 with SMTP id r1-20020a92c501000000b00325b96e6709mr7822955ilg.11.1681164340167;
        Mon, 10 Apr 2023 15:05:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350burg5KwX4O3ylWYs3MtOi8+a2A1RmfQ6dzHFH5uBLbtKPI0Hz4QDU2gr9Ku4MRNPG7lzR+ww==
X-Received: by 2002:a92:c501:0:b0:325:b96e:6709 with SMTP id r1-20020a92c501000000b00325b96e6709mr7822931ilg.11.1681164339894;
        Mon, 10 Apr 2023 15:05:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z12-20020a921a4c000000b003157b2c504bsm3174969ill.24.2023.04.10.15.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 15:05:39 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:05:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: Re: [PATCH v8 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <20230410160538.35c1a5a6.alex.williamson@redhat.com>
In-Reply-To: <20230404190141.57762-5-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
        <20230404190141.57762-5-brett.creeley@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Apr 2023 12:01:38 -0700
Brett Creeley <brett.creeley@amd.com> wrote:
> diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
> new file mode 100644
> index 000000000000..855f5da9b99a
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/lm.c
> @@ -0,0 +1,479 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/highmem.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +#define PDS_VFIO_LM_FILENAME	"pds_vfio_lm"
> +
> +const char *
> +pds_vfio_lm_state(enum vfio_device_mig_state state)
> +{
> +	switch (state) {
> +	case VFIO_DEVICE_STATE_ERROR:
> +		return "VFIO_DEVICE_STATE_ERROR";
> +	case VFIO_DEVICE_STATE_STOP:
> +		return "VFIO_DEVICE_STATE_STOP";
> +	case VFIO_DEVICE_STATE_RUNNING:
> +		return "VFIO_DEVICE_STATE_RUNNING";
> +	case VFIO_DEVICE_STATE_STOP_COPY:
> +		return "VFIO_DEVICE_STATE_STOP_COPY";
> +	case VFIO_DEVICE_STATE_RESUMING:
> +		return "VFIO_DEVICE_STATE_RESUMING";
> +	case VFIO_DEVICE_STATE_RUNNING_P2P:
> +		return "VFIO_DEVICE_STATE_RUNNING_P2P";
> +	default:
> +		return "VFIO_DEVICE_STATE_INVALID";
> +	}
> +
> +	return "VFIO_DEVICE_STATE_INVALID";

Seems a tad redundant.

> +}
> +
[snip]
> +struct file *
> +pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
> +				  enum vfio_device_mig_state next)
> +{
> +	enum vfio_device_mig_state cur = pds_vfio->state;
> +	struct device *dev = &pds_vfio->pdev->dev;
> +	int err = 0;
> +
> +	dev_dbg(dev, "%s => %s\n",
> +		pds_vfio_lm_state(cur), pds_vfio_lm_state(next));
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
> +		/* Device is already stopped
> +		 * create save device data file & get device state from firmware
> +		 */

Standard multi-line comment style please, we're not under net/ here.

> +		err = pds_vfio_get_save_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		/* Get device state */
> +		err = pds_vfio_get_lm_state_cmd(pds_vfio);
> +		if (err) {
> +			pds_vfio_put_save_file(pds_vfio);
> +			return ERR_PTR(err);
> +		}
> +
> +		return pds_vfio->save_file->filep;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Device is already stopped
> +		 * delete the save device state file
> +		 */
> +		pds_vfio_put_save_file(pds_vfio);
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
> +		/* create resume device data file */
> +		err = pds_vfio_get_restore_file(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return pds_vfio->restore_file->filep;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
> +		/* Set device state */
> +		err = pds_vfio_set_lm_state_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		/* delete resume device data file */
> +		pds_vfio_put_restore_file(pds_vfio);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
> +		/* Device should be stopped
> +		 * no interrupts, dma or change in internal state
> +		 */
> +		err = pds_vfio_suspend_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		return NULL;
> +	}

The comment here, as well as the no-op transitions from STOP->P2P and
P2P->STOP has me concerned whether a device in this suspend state
really meets the definition of our P2P state.  The RUNNING_P2P state is
a quiescent state where the device must accept access, including
peer-to-peer DMA, but it cannot initiate DMA or interrupts.  Is that
consistent with this suspend state?  Thanks,

Alex

> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_RUNNING) {
> +		/* Device should be functional
> +		 * interrupts, dma, mmio or changes to internal state is allowed
> +		 */
> +		err = pds_vfio_resume_device_cmd(pds_vfio);
> +		if (err)
> +			return ERR_PTR(err);
> +
> +		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
> +						    PDS_LM_STA_NONE);
> +		return NULL;
> +	}
> +
> +	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING_P2P)
> +		return NULL;
> +
> +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_STOP)
> +		return NULL;
> +
> +	return ERR_PTR(-EINVAL);
> +}

