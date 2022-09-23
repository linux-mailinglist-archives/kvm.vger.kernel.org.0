Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA85E85EC
	for <lists+kvm@lfdr.de>; Sat, 24 Sep 2022 00:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiIWWeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 18:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIWWeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 18:34:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46072121E50
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663972456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QjPylOtZhZgJWUTi5JLfx6pIoX24SMuAcw+6N7ICti0=;
        b=TDGVEtC5rCiOhaCKLyMhV8IZJc584Cup8BTmXuYLeoslMbwH3PAe6qaMDz90TxPUV6p10O
        gkBn+tJrp5HCV2cjKFdJwA52ZAkKMCEoue2yNtYW/IjA0HLqyj8R8P7aNsJ5HL61yAzaq1
        LqGFue3s1JLdeOgwpGzVNeP9lAIKLJM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-175-mYVgiA7CMseVm3Pr-n66hQ-1; Fri, 23 Sep 2022 18:34:15 -0400
X-MC-Unique: mYVgiA7CMseVm3Pr-n66hQ-1
Received: by mail-qv1-f70.google.com with SMTP id i10-20020ad45c6a000000b004a25d0fea96so808740qvh.3
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 15:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=QjPylOtZhZgJWUTi5JLfx6pIoX24SMuAcw+6N7ICti0=;
        b=TxyIsCzw6a8aVnxdjXyLu5rMnxxVmbxHv5O614/oyP7jIF9X2evpEUPIEq5YpWxa3S
         o0+j9uaCFYKiXhmVplSgA+aEkVjJogcw7leOMSAPSJvRT/at0PRlxD3YjINg5ZAULvhH
         hSGi8aEJ3CARgIf1GHpDOPaKbxnJEz/+TemSVOyvpeT2IJTSIt2a1lOWt/S+CPhM5TiT
         iR+e1NXnv2SP64KgcjhIzkqj9hcPGGFuVERsF1Wdj+ZdZDJ3Uq8CcGjQiM7uaoJ/6Zi/
         RgL6TzuZyRu0nepXQqoINdPEja4BRQvDHxFDhTd31D7sOWrJXeGuO5R8CWDuq+CoJx2k
         ezJQ==
X-Gm-Message-State: ACrzQf14pDoBLjGhxVuomxKFVIOxxTcfleRy+vRm1vr/JIwvd4WeiGKl
        9cOuzzIgRBNtbS6P+Vt78jriq3aC6BatrSR6cjX9g6Bomxev4u+eLHNpw5X9EKvKTNVCsRTHs1L
        T9tqJ3g8PjiNT
X-Received: by 2002:a05:6214:d05:b0:4ac:daac:f1c4 with SMTP id 5-20020a0562140d0500b004acdaacf1c4mr8791531qvh.84.1663972454922;
        Fri, 23 Sep 2022 15:34:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7FZ8svHWLCr/HF5fZzqZANH67wTnrKlJonLnDKcL/yasAB8/oLErHjl3FwG3KhZjNbvOKFsw==
X-Received: by 2002:a05:6214:d05:b0:4ac:daac:f1c4 with SMTP id 5-20020a0562140d0500b004acdaacf1c4mr8791515qvh.84.1663972454749;
        Fri, 23 Sep 2022 15:34:14 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id u5-20020a37ab05000000b006b8e8c657ccsm6521149qke.117.2022.09.23.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 15:34:14 -0700 (PDT)
Date:   Fri, 23 Sep 2022 18:34:12 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        KVM ARM <kvmarm@lists.cs.columbia.edu>,
        kvm <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ben Gardon <bgardon@google.com>, Shuah Khan <shuah@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Zhenyu Zhang <zhenyzha@redhat.com>,
        Shan Gavin <shan.gavin@gmail.com>,
        Guowen Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <Yy40ZPS4Lp0S6pkf@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local>
 <87czbmjhbh.wl-maz@kernel.org>
 <Yy36Stppz4tYBPiP@x1n>
 <CABgObfakosSMDYnT+W1zFJCRwPcM7VaY-FJzRs_9NivvhfjnyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABgObfakosSMDYnT+W1zFJCRwPcM7VaY-FJzRs_9NivvhfjnyA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 11:23:24PM +0200, Paolo Bonzini wrote:
> Il ven 23 set 2022, 20:26 Peter Xu <peterx@redhat.com> ha scritto:
> >
> > > Someone will show up with an old userspace which probes for the sole
> > > existing capability, and things start failing subtly. It is quite
> > > likely that the userspace code is built for all architectures,
> >
> > I didn't quite follow here.  Since both kvm/qemu dirty ring was only
> > supported on x86, I don't see the risk.
> 
> Say you run a new ARM kernel on old userspace, and the new kernel uses
> KVM_CAP_DIRTY_LOG_RING. Userspace will try to use the dirty page ring
> buffer even though it lacks the memory barriers that were just
> introduced in QEMU.
> 
> The new capability means "the dirty page ring buffer is supported and,
> by the way, you're supposed to do everything right with respect to
> ordering of loads and stores; you can't get away without it like you
> could on x86".

I understand now, thanks both.

-- 
Peter Xu

