Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469D157545F
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239659AbiGNSE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 14:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239569AbiGNSE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 14:04:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BDCB14009
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657821864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t+X/LTVeJIh6Pv4oi74nXgMhmPni14FKrfpm6fMKedQ=;
        b=Af4p65wk68Ia48LtALWpYOOy/vNdCuZQ7+0wpjRCOcJKCgyVwheEfo/A5hosQ9j+ABmUIj
        DQsAy8J13CCS/QEDkugfTvzMe/lRPy9AW2y0wp5XxbE/vDb7MKxlorcF2xLNBr5ogkKQiv
        J9T4p29f+Z5aMrH6ajLMyEPhq/qHGFE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-kvhe5feZNLCz8x2WluHCKg-1; Thu, 14 Jul 2022 14:04:16 -0400
X-MC-Unique: kvhe5feZNLCz8x2WluHCKg-1
Received: by mail-qt1-f200.google.com with SMTP id i14-20020ac84f4e000000b0031eb16d8b42so2049399qtw.14
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 11:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t+X/LTVeJIh6Pv4oi74nXgMhmPni14FKrfpm6fMKedQ=;
        b=WSC2ZP15J7lcvc6BATz+8ZE7b26pXM/GS8tBzjQlLc9YxwTkqphItYVqhKVESm6qHr
         6xh+hp3LgCUMoqRB6EqdARbgD2eqKqtrCJjEA6hUrAwy5VWFrnNJcGB/MlMQB9ev119K
         wu3xlPN/IoM7yaXt4jT6TWqJ0TLWncH0+JxCnUbsGcKJKgnejTRCZ4QyjJABuxAzJcJA
         aJPBM2aTwNUJXqm6QRtw6MOWaJsrIyO568GVmmgWOHpLB0asiAD49nIoMNjUWkLlvmy4
         lxUl0DCjwDNKiIkCTN4ux+XEhtjWqZfJvNL4T0d47vs7JoNFkzRMxTdGjnlzNPtd2GkA
         OEqQ==
X-Gm-Message-State: AJIora+iX/z3lrgrLTNwDk0bg1Qp5Q4KiqXhBc/YRJMJzyMZoJqGZW/L
        cyXfvWIL+Q7zZx20CKMA6+KI/VmK8/vQwAD2na61w6Qt5rBZiLgNGLiw29nEhrovFcpDoxC+eTF
        YUTcng7y7wNhv
X-Received: by 2002:a05:620a:424e:b0:6ab:96ea:40cb with SMTP id w14-20020a05620a424e00b006ab96ea40cbmr7002140qko.483.1657821855789;
        Thu, 14 Jul 2022 11:04:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u4HcruKSStBv0DAqf7dd7y65BXo3CvX+r654hsKSlKvczrIwchsoykJhErIXZPuQwckyNZAg==
X-Received: by 2002:a05:620a:424e:b0:6ab:96ea:40cb with SMTP id w14-20020a05620a424e00b006ab96ea40cbmr7002114qko.483.1657821855530;
        Thu, 14 Jul 2022 11:04:15 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id cq9-20020a05622a424900b0031ecebecebcsm1949590qtb.86.2022.07.14.11.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 11:04:14 -0700 (PDT)
Date:   Thu, 14 Jul 2022 14:04:13 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtBanRozLuP9qoWs@xz-m1.local>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org>
 <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Shivam,

On Tue, Jul 05, 2022 at 12:51:01PM +0530, Shivam Kumar wrote:
> Hi, here's a summary of what needs to be changed and what should be kept as
> it is (purely my opinion based on the discussions we have had so far):
> 
> i) Moving the dirty quota check to mark_page_dirty_in_slot. Use kvm requests
> in dirty quota check. I hope that the ceiling-based approach, with proper
> documentation and an ioctl exposed for resetting 'dirty_quota' and
> 'pages_dirtied', is good enough. Please post your suggestions if you think
> otherwise.

An ioctl just for this could be an overkill to me.

Currently you exposes only "quota" to kvm_run, then when vmexit you have
exit fields contain both "quota" and "count".  I always think it's a bit
redundant.

What I'm thinking is:

  (1) Expose both "quota" and "count" in kvm_run, then:

      "quota" should only be written by userspace and read by kernel.
      "count" should only be written by kernel and read by the userspace. [*]

      [*] One special case is when the userspace found that there's risk of
      quota & count overflow, then the userspace:

        - Kick the vcpu out (so the kernel won't write to "count" anymore)
        - Update both "quota" and "count" to safe values
        - Resume the KVM_RUN

  (2) When quota reached, we don't need to copy quota/count in vmexit
      fields, since the userspace can read the realtime values in kvm_run.

Would this work?

> ii) The change in VMX's handle_invalid_guest_state() remains as it is.
> iii) For now, we are lazily updating dirty quota, i.e. we are updating it
> only when the vcpu exits to userspace with the exit reason
> KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.

At least with above design, IMHO we can update kvm_run.quota in real time
without kicking vcpu threads (the quota only increases except the reset
phase for overflow).  Or is there any other reason you need to kick vcpu
out when updating quota?

Thanks,

-- 
Peter Xu

