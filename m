Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167E14DE132
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 19:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbiCRSkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 14:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiCRSka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 14:40:30 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2591C9462
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 11:39:11 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id e22so10229964ioe.11
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 11:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gdcxn84q8DHr+ZqDpXKDnxIDZKtCn2A0Yj7xVLp1LqY=;
        b=ImDuDi7qi1ebIrWkTQC494ZYXd9cwuO738VIshjrSd26wTWSBqMFySFt/SmTGHPKDF
         0JCp+YnQsHzWvrZT5RqEoQGCH3GZ4wEA1MLflwV56w7CykT7Fjvzz09FKS9+fhChpaKn
         832T7PA9nIrkdsiiCNsn8cIU3SkJHFbWpVlbVPjzh57/BeK/pvTJQFshua/VKTazBMSJ
         LTlCBBsXAzIF5/uNuXJZb9asnHHQXKF89Ck6A9g+JyJ4vsNWEHNvCSM5BMBbPyDZOifP
         aV6qzIHlp2g7l7jxpQl0k2efbWbyO+p2gfI4D+CQTG9+NWD8mtrGRlw8N277yXXJb4aA
         hpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gdcxn84q8DHr+ZqDpXKDnxIDZKtCn2A0Yj7xVLp1LqY=;
        b=bZ6FzqBrC7BF/m99snK0/nkjBDRid7Dz5NJVqLyNhSb/Iz4jEyne9rf1v4XAW+XTtH
         2FLBER5vrZM5i7fAVpuhK84fpJrXVl2OO4DNJEam38v4nx24ViQUWSuI1y3simEpuM7o
         Y6VHbv8Vi0KkQ8Qr+78R2+5VoeiDeVMSJbjMx6rj+TOLAYjKi92AOcVZ1/lhzu2mEa2F
         QV5bhjD47CJDAI9T2dQmnGlgJAVtHGhHqxiPIGXOmHtE7+/kthPupxeYHhGElVdCvwhb
         hqlRKpyLEuR5YTkaKOvgtRtjmdABuGChFk75OIU6cZiyfs2UFPlB2r42cuLdngPf/uYJ
         Fi5Q==
X-Gm-Message-State: AOAM5338bz2l7FyDVIi9HAL/dcN+jpmblyu+igDeW2abY4cxB7Dn6lyD
        r3ga2QX/N9NjkQPjRQzz8XDNWw==
X-Google-Smtp-Source: ABdhPJx1jWDVVQHNx9gQsUX/EG+K+nBlr+GI60D/OvTnfnQ5g/1C1zbBnAuxxWUmNXZAb2wbCQNu3g==
X-Received: by 2002:a05:6638:388f:b0:319:c876:fa0 with SMTP id b15-20020a056638388f00b00319c8760fa0mr5074072jav.7.1647628750458;
        Fri, 18 Mar 2022 11:39:10 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id i8-20020a056e020ec800b002c7724b83cbsm4980522ilk.55.2022.03.18.11.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 11:39:09 -0700 (PDT)
Date:   Fri, 18 Mar 2022 18:39:06 +0000
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
Message-ID: <YjTRyssYQhbxeNHA@google.com>
References: <20220316045308.2313184-1-oupton@google.com>
 <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
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

Hi Paolo,

On Wed, Mar 16, 2022 at 08:47:59AM +0100, Paolo Bonzini wrote:
> On 3/16/22 05:53, Oliver Upton wrote:
> > The VMM has control of both the guest's TSC scale and offset. Extend the
> > described migration algorithm in the KVM_VCPU_TSC_OFFSET documentation
> > to cover TSC scaling.
> > 
> > Reported-by: David Woodhouse<dwmw@amazon.co.uk>
> > Signed-off-by: Oliver Upton<oupton@google.com>
> > ---
> > 
> > Applies to kvm/queue (references KVM_{GET,SET}_TSC_KHZ on a VM fd).
> 
> A few more things that have to be changed:
> 
> > 1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_src),
> >    kvmclock nanoseconds (guest_src), and host CLOCK_REALTIME nanoseconds
> >    (host_src).
> > 
> 
> One of two changes:
> 
> a) Add "Multiply tsc_src by guest_freq / src_freq to obtain scaled_tsc_src",
> add a new device attribute for the host TSC frequency.
> 
> b) Add "Multiply tsc_src by src_ratio to obtain scaled_tsc_src", add a new
> device attribute for the guest_frequency/host_frequency ratio.
> 
> A third would be scaling the host TSC frequency in KVM_GETCLOCK, but that's
> confusing IMO.

Agreed -- I think kvmclock should remain as is.

A fourth would be to expose the host's TSC frequency outside of KVM
since we're really in the business of guest features, not host ones :-)
We already have a patch that does this internally, and its visible in
some of our open source userspace libraries [1].

That said, I do not have any immediate reservations about adding an
attribute as the easy way out.

Ack on the rest of the feedback, I'll touch up the documentation further
once we figure out TSC frequency exposure.

[1]: https://github.com/abseil/abseil-cpp/blob/c33f21f86a14216336b87d48e9b552a13985b2bc/absl/base/internal/sysinfo.cc#L311

--
Thanks,
Oliver
