Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5C774E3E
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 00:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjHHW17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 18:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHHW16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 18:27:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5CFFE
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 15:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691533629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hS39YmSrQH272Sq7YFizIeVa2aB1z7GDjNayvnX9oro=;
        b=A4b0wXj6zzY2PHQK8sJ9S/iW3pesJZXh0W3jg6MmftLjMc3q4C4aFmW2T0V3g9jgvleCDP
        F+5PZRIEzQ609iqIpxKGTsv82pxztMlmNro8EqsRVo3fcOYAQz7YYzrLAUUoKTpqkysLrM
        veNK8Qk+OtrrF8vpy6Cf+OIx3ih1Bxc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-SrZ-gJd9P3a2cK3Ku93rFg-1; Tue, 08 Aug 2023 18:27:07 -0400
X-MC-Unique: SrZ-gJd9P3a2cK3Ku93rFg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-348c80e65e8so2351275ab.0
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 15:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691533626; x=1692138426;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hS39YmSrQH272Sq7YFizIeVa2aB1z7GDjNayvnX9oro=;
        b=cpX5Y1T4RwKQb5VYQEYyqFdCWCvRaNUDZGXmpwbfVlqm2dtpCpdoT+HJ+0RaspLlrf
         VTyhOnLcHQ99QJdkATJ9ISDf0Y+MTWju+RMHK6OOZEb2/UZLjMF12ZA7riSrlVUUG6tB
         T70LddRBhUZmvzT8+/vw6ZOa41TDSNzTLytykFGcfX7eHWinFpzxhIVhZkONXPg03XXW
         Png2XaBeBFPNOhB8G3rwJLQVj7a9Mh/ROkpgNSccr59pJLW4w7h8dlZlqogiiDqJR0b0
         nXjD8jXbI1xLEfPVsbMAol5riiBFPRtNmV2wm/YAaWFSVhNv6Xba3jEXQhwnQT0VZ2li
         BHKA==
X-Gm-Message-State: AOJu0YwqB7/R427rKc/3aDY0gaB51Z/h5N0wrMJu6weAflIdwHngqFOJ
        GBMPowlgteZ92uR1UE3CXFR2XioIQ+A4RRwiseier4BjkPRKTkzLbfmArl55MFJqptDC50Qo5Rz
        VBGySHXA7gz/o
X-Received: by 2002:a05:6e02:1d86:b0:343:ef5e:8286 with SMTP id h6-20020a056e021d8600b00343ef5e8286mr13234040ila.7.1691533626677;
        Tue, 08 Aug 2023 15:27:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMm9KfjjWw52fsFiv8nxxh7g73FJ1lmfP3fvwhxeCO7jsmGfkp4Lznxrqr6JPvoS6MznPNpA==
X-Received: by 2002:a05:6e02:1d86:b0:343:ef5e:8286 with SMTP id h6-20020a056e021d8600b00343ef5e8286mr13234032ila.7.1691533626459;
        Tue, 08 Aug 2023 15:27:06 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id t15-20020a92d14f000000b00348730b48a1sm3697864ilg.43.2023.08.08.15.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 15:27:05 -0700 (PDT)
Date:   Tue, 8 Aug 2023 16:27:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <horms@kernel.org>,
        <shannon.nelson@amd.com>
Subject: Re: [PATCH v14 vfio 5/8] vfio/pds: Add VFIO live migration support
Message-ID: <20230808162704.7f5d4889.alex.williamson@redhat.com>
In-Reply-To: <20230807205755.29579-6-brett.creeley@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
        <20230807205755.29579-6-brett.creeley@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Aug 2023 13:57:52 -0700
Brett Creeley <brett.creeley@amd.com> wrote:
...
> +static int
> +pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	union pds_core_adminq_cmd cmd = {
> +		.lm_suspend_status = {
> +			.opcode = PDS_LM_CMD_SUSPEND_STATUS,
> +			.vf_id = cpu_to_le16(pds_vfio->vf_id),
> +		},
> +	};
> +	struct device *dev = pds_vfio_to_dev(pds_vfio);
> +	union pds_core_adminq_comp comp = {};
> +	unsigned long time_limit;
> +	unsigned long time_start;
> +	unsigned long time_done;
> +	int err;
> +
> +	time_start = jiffies;
> +	time_limit = time_start + HZ * SUSPEND_TIMEOUT_S;
> +	do {
> +		err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, true);
> +		if (err != -EAGAIN)
> +			break;
> +
> +		msleep(SUSPEND_CHECK_INTERVAL_MS);
> +	} while (time_before(jiffies, time_limit));
> +
> +	time_done = jiffies;
> +	dev_dbg(dev, "%s: vf%u: Suspend comp received in %d msecs\n", __func__,
> +		pds_vfio->vf_id, jiffies_to_msecs(time_done - time_start));
> +
> +	/* Check the results */
> +	if (time_after_eq(time_done, time_limit)) {
> +		dev_err(dev, "%s: vf%u: Suspend comp timeout\n", __func__,
> +			pds_vfio->vf_id);
> +		err = -ETIMEDOUT;

If the command completes successfully but exceeds the time limit
this turns a success into a failure.  Is that desired?  Thanks,

Alex

