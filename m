Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2760C4DE6E3
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 09:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242421AbiCSIB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 04:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiCSIBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 04:01:25 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF618BF11
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 01:00:03 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id b16so11694150ioz.3
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 01:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QsQIMwAS01jzHTBrlb3tvUw43YLm3+pONMCDkEdD09M=;
        b=QGz2IhpgU4bZ8yZgKGnOBkdWfzBYgY969H3i3Kk9X/Z0TaYmVluJW0hSGDCVdrBe2e
         bw+pibvT/ULEo2D0gRB/RHf/Tf/iFq1Emi8tAWHv9FekzPc6SxUbIwLilKJYd6ku6XD6
         22NHnrYFXPyvHW/vU9qHxgSjXz8lfNNruEsq2E0vJH47FF1ygCZnI8OziDaboOi/Xm9o
         VGa8iH5iA/ZSde5Bj/+hrCCJiYpnwKG0TYmyJJ6+08fJGxnOG8Json7nGzaMtkSTUyTq
         S7lrgGdvgaLPnLOJUvvyeATszwXYIfZEF/454coiWQAnzUU3JOG6WjIOylh0aGxwxZTw
         MpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QsQIMwAS01jzHTBrlb3tvUw43YLm3+pONMCDkEdD09M=;
        b=uDBic8Kaz7UgStx3TifiHL8/SY7sD+0qzScublmEjw5UHDSJvjgmswtkQCUfsV1+US
         Dnj3YMGOKUqTZw18UMdRO6uIEoG35gQBZgsV+0Je+U7+klXOrV1dhq5MNqtjMWN7JdnX
         8VyUDq6fa6kO+VgOp59UmNrwAJzfpUOymzXbhbmlUWGqLNTzAS6D+IiCcMvOmfgSoplD
         z/DHsZPQERpN/0vaPzEikRDfmDu77wqB82+ujlT85P6fU8i19wGkHINBzgbkK9lQB6uY
         4tv9JMy1+3c9usu94QQhd1F8Q4IBZPXLJT3ldIiZzmZ1Qwy0LU5fZ9+iBiDcec60AMA3
         BrAA==
X-Gm-Message-State: AOAM532ETCkIhfyPNTFo+qFhh1K5DZLULhiM3oxl968r3lFEZ5Uq6Uka
        HmgD6hChqWRrb40ejZP0gaz4zg==
X-Google-Smtp-Source: ABdhPJyksd25IESmW3IcbOvCoRCX0xlfdlD/UD7apqmaJ7DW9dGhl6eRpc8zMF77kfggRR6FSMFGfg==
X-Received: by 2002:a05:6602:2dd4:b0:649:4274:eddc with SMTP id l20-20020a0566022dd400b006494274eddcmr6121386iow.68.1647676801540;
        Sat, 19 Mar 2022 01:00:01 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id b25-20020a5d8059000000b00644ddaad77asm5565818ior.29.2022.03.19.01.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 01:00:00 -0700 (PDT)
Date:   Sat, 19 Mar 2022 07:59:57 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Message-ID: <YjWNfQThS4URRMZC@google.com>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
 <YjTRyssYQhbxeNHA@google.com>
 <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 19, 2022 at 08:52:56AM +0100, Paolo Bonzini wrote:
> On 3/18/22 19:39, Oliver Upton wrote:
> > Hi Paolo,
> > 
> > On Wed, Mar 16, 2022 at 08:47:59AM +0100, Paolo Bonzini wrote:
> > > On 3/16/22 05:53, Oliver Upton wrote:
> > > > The VMM has control of both the guest's TSC scale and offset. Extend the
> > > > described migration algorithm in the KVM_VCPU_TSC_OFFSET documentation
> > > > to cover TSC scaling.
> > > > 
> > > > Reported-by: David Woodhouse<dwmw@amazon.co.uk>
> > > > Signed-off-by: Oliver Upton<oupton@google.com>
> > > > ---
> > > > 
> > > > Applies to kvm/queue (references KVM_{GET,SET}_TSC_KHZ on a VM fd).
> > > 
> > > A few more things that have to be changed:
> > > 
> > > > 1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_src),
> > > >     kvmclock nanoseconds (guest_src), and host CLOCK_REALTIME nanoseconds
> > > >     (host_src).
> > > > 
> > > 
> > > One of two changes:
> > > 
> > > a) Add "Multiply tsc_src by guest_freq / src_freq to obtain scaled_tsc_src",
> > > add a new device attribute for the host TSC frequency.
> > > 
> > > b) Add "Multiply tsc_src by src_ratio to obtain scaled_tsc_src", add a new
> > > device attribute for the guest_frequency/host_frequency ratio.
> > > 
> > > A third would be scaling the host TSC frequency in KVM_GETCLOCK, but that's
> > > confusing IMO.
> > 
> > Agreed -- I think kvmclock should remain as is.
> > 
> > A fourth would be to expose the host's TSC frequency outside of KVM
> > since we're really in the business of guest features, not host ones :-)
> > We already have a patch that does this internally, and its visible in
> > some of our open source userspace libraries [1].
> 
> Yeah, it was a bit of a cop out on my part but adding it to sysfs would be
> nice.  Please tell me if any of you going to send a patch, or even just
> share it so that I can handle the upstream submission.

I'll have some time to look at it next week and send upstream. I was
somewhat panning if there were any other ideas here, but sysfs does seem
sensible :)

--
Thanks,
Oliver
