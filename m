Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C66D12A8
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 00:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjC3Wzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjC3Wzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 18:55:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09166113E0
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680216889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JOZavLISqTLbnfJw42DZFA+KP5NnmmtSq2crESdk0I=;
        b=JSuAJ0jLscui8oIr8rbkhqCbKGYomzMhZBm06HDLEospFHEk1spqEeIGXNPKwlpZ8RRC3q
        Fd2uCzRjWEjkaB20RreL4l7+uVGvMz4FT1TFeP3Chj7JhMYwEe//4JezdxVl1O91CWazLe
        id0u2p5eIwrHHpWGaZp4+eUMTNOE5hk=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-k_gwhY0YOHytVad5x6Q9sA-1; Thu, 30 Mar 2023 18:54:47 -0400
X-MC-Unique: k_gwhY0YOHytVad5x6Q9sA-1
Received: by mail-il1-f200.google.com with SMTP id o15-20020a056e02102f00b003261821bf26so7655293ilj.1
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 15:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680216887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3JOZavLISqTLbnfJw42DZFA+KP5NnmmtSq2crESdk0I=;
        b=LWoqdytdh93ntE/rsLsi5V4DmThnO9H1sXS1BzjKluniabdwAcIOJV2Cg1bseUp1ow
         bkMq0LDEf7mNwKuwBE5kq8nhsPqvBI5Xd8pByo6Y4rYYq0p/+TTeVOefBkrwYbWFc8hA
         1SPoggInqDn/UHUPjbNBfl1/yZja9GIa9ujX36C9pEzwdOz/qrinLhKaNS2Rppn8XL3g
         zZMQqYcjGRtStpqgFpW/+7+TZu3by6rx+UbMqfEy0QhOBGE9GVnadWU7wlR9pVQbQEoA
         QjLG/o1k5wpShlZP+GYCjURkatwF2AxfG5e4h5IhuMKwumOEW/5f3Kr2Fe3vLT6jogz+
         lNKA==
X-Gm-Message-State: AAQBX9cTqYR9QvPbPGY8Lm4C5WhKCfUX8kjhYjAtTmxCVCbuD76x4CJ1
        W4aQ8tEzjTfhrLltD1q1A6CJaRAi1+MiGErnFM3S8xUn93CtypHu3bmkk41Rv3Ut6e38BX4/pSL
        27S3agpLYHleL
X-Received: by 2002:a05:6e02:20e7:b0:325:dc0c:73f5 with SMTP id q7-20020a056e0220e700b00325dc0c73f5mr5108241ilv.14.1680216887097;
        Thu, 30 Mar 2023 15:54:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350YXsgDDWR7rGm3AoYHtLVMhrfTUCDklj5XWYST4S8YNlU1G2QuKx6gSG4ldROtn4Am9LQ7kqQ==
X-Received: by 2002:a05:6e02:20e7:b0:325:dc0c:73f5 with SMTP id q7-20020a056e0220e700b00325dc0c73f5mr5108231ilv.14.1680216886847;
        Thu, 30 Mar 2023 15:54:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o189-20020a0222c6000000b003afc548c3cdsm212851jao.166.2023.03.30.15.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 15:54:46 -0700 (PDT)
Date:   Thu, 30 Mar 2023 16:54:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <tglx@linutronix.de>, <darwi@linutronix.de>, <kvm@vger.kernel.org>,
        <dave.jiang@intel.com>, <jing2.liu@intel.com>,
        <ashok.raj@intel.com>, <fenghua.yu@intel.com>,
        <tom.zanussi@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/8] vfio/pci: Remove negative check on unsigned
 vector
Message-ID: <20230330165445.7bf7cdd6.alex.williamson@redhat.com>
In-Reply-To: <460fdc5f-7613-5164-0247-254939cedc71@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
        <0dc2a0c8e25b13a3a41db75ab192f387a1548c80.1680038771.git.reinette.chatre@intel.com>
        <20230330142657.3930c68b.alex.williamson@redhat.com>
        <460fdc5f-7613-5164-0247-254939cedc71@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Thu, 30 Mar 2023 15:32:20 -0700
Reinette Chatre <reinette.chatre@intel.com> wrote:

> Hi Alex,
> 
> On 3/30/2023 1:26 PM, Alex Williamson wrote:
> > On Tue, 28 Mar 2023 14:53:29 -0700
> > Reinette Chatre <reinette.chatre@intel.com> wrote:  
> ...
> 
> >> @@ -399,7 +399,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
> >>  static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
> >>  			      unsigned count, int32_t *fds, bool msix)
> >>  {
> >> -	int i, j, ret = 0;
> >> +	int i, ret = 0;
> >> +	unsigned int j;
> >>  
> >>  	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
> >>  		return -EINVAL;  
> > 
> > Unfortunately this turns the unwind portion of the function into an
> > infinite loop in the common case when @start is zero:
> > 
> >                 for (--j; j >= (int)start; j--)
> >                         vfio_msi_set_vector_signal(vdev, j, -1, msix);
> > 
> >   
> 
> Thank you very much for catching this. It is not clear to me how you
> would prefer to resolve this. Would you prefer that the vector parameter
> in vfio_msi_set_vector_signal() continue to be an int and this patch be
> dropped and the "if (vector < 0)" check remains (option A)? Or, alternatively,
> I see two other possible solutions where the vector parameter in
> vfio_msi_set_vector_signal() becomes an unsigned int and the above snippet
> could be one of:
> 
> option B:
> vfio_msi_set_block()
> {
> 	int i, j, ret = 0;
> 
> 	...
> 		for (--j; j >= (int)start; j--)
> 			vfio_msi_set_vector_signal(vdev, (unsigned int)j, -1, msix);
> }
> 
> option C:
> vfio_msi_set_block()
> {
> 	int i, ret = 0;
> 	unsigned int j;
> 
> 	...
> 		for (--j; j >= start && j < start + count; j--)
> 			vfio_msi_set_vector_signal(vdev, j, -1, msix);
> }
> 
> What would you prefer?


Hmm, C is fine, it avoids casting.  I think we could also do:

	unsigned int i, j;
	int ret = 0;

	...

		for (i = start; i < j; i++)
			vfio_msi_set_vector_signal(vdev, i, -1, msix);

Thanks,
Alex

