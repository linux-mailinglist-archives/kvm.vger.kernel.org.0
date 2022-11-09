Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE4622F99
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 17:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiKIQEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 11:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiKIQEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 11:04:14 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393621E34
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 08:04:09 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g24so17511955plq.3
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 08:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PlykdZf53Ohav7cpBvJLcIzsQz5x8VOD7o5U9nHXBgc=;
        b=bVvZJoOZs7e7GLjkcGaVoCXuVnciZ1hf67dR2sIP31xMWxFKEw8uPJ+5aKil1qUiY5
         tA4hHAEuqMWFCOTuDU0VfWTSuhl1MN0tSfNV3gyf9O1n7QkkHwcxj/ukF9yIWZFG28GW
         m+KM7hMiDQWXZqK8idr6qO73WY82ZwyctPwEP2fL6gP+DtHJvfmvyyjVfCltbL1HgOmw
         JHu62oIcFJKdp6bDzAh362254ck430R/u74KW0xlpLeSIHeG+Hn7iJCp9CMDSmSYLhnK
         2X18yWqnShWw/YKs91t+L21FB3XjGVVxbtVdSrNIfkF8zy2MKL/+9bWqLUSzNabv9RAh
         cQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PlykdZf53Ohav7cpBvJLcIzsQz5x8VOD7o5U9nHXBgc=;
        b=jhZ2Ll8p/42Xs4MXHGJ2IMU8SCC5Ic/x3fxzcrSWeuWl/HiO6OC1EMhTlHpyC/U2m9
         gmmanqvPvrc8ug17XRyA89hPdx2gjdGirYtpSatOhwWaofJ4ffccTbbqsiYL1otC2t+s
         UWmgxTvbktPCXpnK8Lc41kjvZP2dQ6z7O8BZOMdDv/kjv+FppLZZ5J0iL8cEh6ZcwTev
         EbZ0Ntmu1TJBcKUF8lyoLBj3Gsfn63mdCQ3+hB03c0nV6HCah/3laZersio9LwS9IkcW
         zPHF9HJuUQ3AyTnthVYq3ERYajwrKc96G6agh5TxJ2uvpgSHjh6sIA14xoXUWtRoHjtp
         Ea2Q==
X-Gm-Message-State: ACrzQf0pcY5QpcEcilNtBIdego4NiQq0eRhA/ZW3jsubsggJfwGl3wzm
        8GoDFDw0eH3EhWqrYp4waeqzaw==
X-Google-Smtp-Source: AMsMyM5r7itnx/WssDX8W4piTmS5ul2s3O+hGE4zRV5yinNI3yGcF6u0iFxPODP6CHrAsjqjted4LQ==
X-Received: by 2002:a17:90b:3013:b0:213:ab5f:d388 with SMTP id hg19-20020a17090b301300b00213ab5fd388mr61518084pjb.66.1668009849099;
        Wed, 09 Nov 2022 08:04:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b00186c41bd213sm9320430plg.177.2022.11.09.08.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 08:04:08 -0800 (PST)
Date:   Wed, 9 Nov 2022 16:04:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 10/11] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to
 assembly
Message-ID: <Y2vPdDLAtZYMRoef@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-11-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-11-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> Restoration of the host IA32_SPEC_CTRL value is probably too late
> with respect to the return thunk training sequence.
> 
> With respect to the user/kernel boundary, AMD says, "If software chooses
> to toggle STIBP (e.g., set STIBP on kernel entry, and clear it on kernel
> exit), software should set STIBP to 1 before executing the return thunk
> training sequence." I assume the same requirements apply to the guest/host
> boundary. The return thunk training sequence is in vmenter.S, quite close
> to the VM-exit. On hosts without V_SPEC_CTRL, however, the host's
> IA32_SPEC_CTRL value is not restored until much later.
> 
> To avoid this, move the restoration of host SPEC_CTRL to assembly and,
> for consistency, move the restoration of the guest SPEC_CTRL as well.
> This is not particularly difficult, apart from some care to cover both
> 32- and 64-bit, and to share code between SEV-ES and normal vmentry.
> 
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +.ifnc _ASM_ARG1, _ASM_DI
> +	/*
> +	 * Stash @svm in RDI early. On 32-bit, arguments are in RAX, RCX
> +	 * and RDX which are clobbered by RESTORE_GUEST_SPEC_CTRL.
> +	 */
> +	mov %_ASM_ARG1, %_ASM_DI
> +.endif

Not technically needed since SEV-ES is 64-bit only, but that's a pre-exisiting
mess.  I'll send a follow-up patch to #ifdef out the entire function and drop all
of this internal ifdeffery, and provide a stub in C code stub in C code so that
32-bit can link (and kill the VM if if the stub is reached).
