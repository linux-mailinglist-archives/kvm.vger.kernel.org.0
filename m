Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F63865F779
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 00:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbjAEXHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 18:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjAEXHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 18:07:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A06676DC
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 15:07:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w3so9286923ply.3
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 15:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wRRyvA8Fr1E+rOE/OGzuk956gOrQfv+4IiVV2tYEfLM=;
        b=HukiQR501GM8nFa78JATDI7UgoOHlgrMNYbZMzOYHvcUu+px7ebfeH6ZVtaFWaB7W4
         udT5g2bd4kdoiyW/7zI0wcsA/oeBDKEAYrVTu19zTKrigkKhDjJy84qbo1zVyn1wQVJj
         Laub5OdrjhyY9DDRb2CI1XRJ7TskEHXlIVrylELtcE+Qxuz/z+OQjsI+FTdYgd9tievU
         UqVfphmzetKHSBHpxed7Ztym33V4XyP+j5y6wqXa0cAG72RDhM+9RBWY4Xzc+gp1/sLw
         ATFuD0A5CglIFeQKq0DVdxZagyY+JZ8pNZUwd3/aIUVDH/tm60qJaQVPb9ZvvJHu1P3v
         qg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRRyvA8Fr1E+rOE/OGzuk956gOrQfv+4IiVV2tYEfLM=;
        b=JXuQqBA4zmakiKLQzMgSoMuA7QRy5MwYsZugRDUQEPWk0FWB7I8rjXw9XDpDlx9Rc7
         r1S39/I1dv9jdgI6RTZ0z3gqKOs88PsLPQMxPa9l+fwJYcC5wwo+26ctN3qF0soztvht
         l3d0fRUkhUzitQzSaxCYbCr0qH/BYXkE7sU5pVU3HTk1zrucMJnE4jIzzhkVF6hbHJ3U
         +TfOJ1YLNhLDu3x9KbYU8U+pDie3zGy5YXHVErVt2l8H7NYwEC7Yj6WdRyWhg5mXojsN
         1dhBB6OEv3b9DSMjarRBo/vh/N6VA+pbhauHq4c83dDQh1upt2llR9cH4oW+oaEBDWsa
         sTyg==
X-Gm-Message-State: AFqh2kp5I2Y0fPJkUYS4o1IS+40FB2PeD7WuCKp5QgqRz9MGr3+6TtkD
        qUd0Jf7RkP42D9nlYB7AjFhVPw==
X-Google-Smtp-Source: AMrXdXvBcDHZcwT3NM+p9EakWQr6KY1Cxr9zVr/hVef/GMiQRkqwVoBD6Fd9imLwZ37W4xdutT8aUQ==
X-Received: by 2002:a05:6a20:6996:b0:b4:1a54:25c6 with SMTP id t22-20020a056a20699600b000b41a5425c6mr56856pzk.1.1672960057709;
        Thu, 05 Jan 2023 15:07:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f2-20020a655502000000b004790eb3fee1sm22003731pgr.90.2023.01.05.15.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 15:07:37 -0800 (PST)
Date:   Thu, 5 Jan 2023 23:07:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>, dwmw2@infradead.org,
        kvm@vger.kernel.org, paul@xen.org
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Message-ID: <Y7dYNR/39fTOuaPR@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
 <20221229211737.138861-2-mhal@rbox.co>
 <Y7RjL+0Sjbm/rmUv@google.com>
 <c33180be-a5cc-64b1-f2e5-6a1a5dd0d996@rbox.co>
 <Y7dN0Negds7XUbvI@google.com>
 <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a4ab7b0-67f3-f686-0471-1ae919d151b5@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023, Paolo Bonzini wrote:
> On 1/5/23 23:23, Sean Christopherson wrote:
> > Ha!  Case in point.  The aforementioned Xen code blatantly violates KVM's locking
> > rules:
> > 
> >    - kvm->lock is taken outside vcpu->mutex
> 
> Ouch yeah, that's not salvageable.  Anything that takes kvm->lock inside
> kvm->srcu transitively has to be taking kvm->lock inside vcpu->mutex as
> well.
> 
> In abstract I don't think that "vcpu->mutex inside kvm->lock" would be a
> particularly problematic rule; kvm->lock critical sections are much shorter
> than vcpu->mutex which covers all of KVM_RUN for example, and that hints at
> making vcpu->mutex the *outer* mutex.  However, I completely forgot the
> sev_lock_vcpus_for_migration case, which is the exception that... well,
> disproves the rule.

Ya, and there are plenty more instances outside of x86.

ARM's vGIC stuff also does similar things, see lock_all_vcpus().

PPC's kvmppc_xive_release() and kvmppc_xics_release().

s390's kvm_s390_cpus_from_pv().
