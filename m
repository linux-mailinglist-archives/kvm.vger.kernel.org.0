Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C1F3318CE
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 21:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCHUn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 15:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhCHUnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 15:43:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8504DC06174A
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 12:43:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so3698260pjq.5
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 12:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JCHmoEg1VJCxXwurok5RvQWW77Zv+Hi+TrTBhfG3tOU=;
        b=VQbnvxaqwj8CRvemi3vkE8V6VJmjTntB0m1/c217PqSaJ2cevn5dorMbRHGhFdNySY
         9QnF9vDDmIMKPG5/fBtc9sguELN11DKOuA6RwTWrRMKD96GAc6Chji9wxRTYOc+KRts0
         XZQ4qLSLrJrw3RvxH7JR8Li8H04xOupvvcHhYLSXw1eQG+KFXXG14EegeZ4fgmFyQcbx
         fBuwpn7LBJ+8OUWgNXhglUlV8oegvVnr4C6JHH6MNrcBd8iB3yGpoSFAHlcc26MJSK49
         oQmYornvXyQCnfFeEfZNB/xMGk1XiCNngdHc79GhpkMAFVaR1O4lxAZ7ZYDWVP4HgVxi
         VfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JCHmoEg1VJCxXwurok5RvQWW77Zv+Hi+TrTBhfG3tOU=;
        b=PDMeLhW1xqMBsqkp71co3Zkl1wLeDUy+T8IrPPbN89JYv48bYtMdgU0dA68VsHLKv6
         6CNMxh9ZjFJV5QcWEQfOnAQI8Of+Lzf6e/PcKTDIXLNeJ8BP7kmkj5vAJ+4keeTEK9xo
         XS/djTvMYp9f1lOR+Z+s/8lXC6iyAt3VL8d1wQVbBzObZTKYMADrcrGBeU3W511jgeLR
         qCVEPy5FkDAUI4ZMEU4Gf7X7QGjfA3fkW3G8dzu3TC6tWV7nlgNaBJue2HJh7gbRn4hC
         28/+etbqPxC5TZVQKaeSMkUQo6s2lreb7aGPsQdf4+JM3EMOgJyGOzmJMtThN1b9onDO
         Qa0w==
X-Gm-Message-State: AOAM532KeQZFLhS2dfF3/G7wMpgx1x9g/x3rVtZxU1k6pruFbFl7Y5Jh
        vR90m/pLOJf7DKs4Be4nO5onUA==
X-Google-Smtp-Source: ABdhPJyVtmgVR3mk3bSEErARIRcFRCV/Ebf9KFplqPAtl020JLZVjbC1h9NiCWRKZZO9puYQrpCBjg==
X-Received: by 2002:a17:90a:8417:: with SMTP id j23mr756073pjn.224.1615236235012;
        Mon, 08 Mar 2021 12:43:55 -0800 (PST)
Received: from google.com ([2620:15c:f:10:8:847a:d8b5:e2cc])
        by smtp.gmail.com with ESMTPSA id ha8sm241837pjb.6.2021.03.08.12.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:43:54 -0800 (PST)
Date:   Mon, 8 Mar 2021 12:43:48 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 03/28] KVM: nSVM: inject exceptions via
 svm_check_nested_events
Message-ID: <YEaMhHG7ylvTpoYD@google.com>
References: <YELdblXaKBTQ4LGf@google.com>
 <fc2b0085-eb0f-dbab-28c2-a244916c655f@redhat.com>
 <YEZUhbBtNjWh0Zka@google.com>
 <006be822-697e-56d5-84a7-fa51f5087a34@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006be822-697e-56d5-84a7-fa51f5087a34@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Paolo Bonzini wrote:
> On 08/03/21 17:44, Sean Christopherson wrote:
> > VMCALL is also probably ok
> > in most scenarios, but patching L2's code from L0 KVM is sketchy.
> 
> I agree that patching is sketchy and I'll send a patch.  However...
> 
> > > The same is true for the VMware #GP interception case.
> > 
> > I highly doubt that will ever work out as intended for the modified IO #GP
> > behavior.  The only way emulating #GP in L2 is correct if L1 wants to pass
> > through the capabilities to L2, i.e. the I/O access isn't intercepted by L1.
> > That seems unlikely.
> 
> ... not all hypervisors trap everything.  In particular in this case the
> VMCS12 I/O permission bitmap should be consulted (which we do in
> vmx_check_intercept_io), but if the I/O is not trapped by L1 it should
> bypass the IOPL and TSS-bitmap checks in my opinion.

I agree, _if_ it's not trapped.  But bypassing the checks when it is trapped is
clearly wrong.
