Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B704720CB8
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 02:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbjFCAx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 20:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbjFCAxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 20:53:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB86E69
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 17:53:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bad1c8dce48so3558371276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685753593; x=1688345593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HkWc440dWqKfJAoTPSU5D4E5Pe2P3uy3rMsCIhe40hk=;
        b=7uEl/J9TvzVsprsjMLqrwf5nORDQHNyPWeCl+qscfM1YZ0S7pYASeEfoV+RCPS64XU
         Hd1M9bKzQJrOhyi74jNjZok4LSsXA02fvinmTcuXngeVs/bpn5kLdcWTM0R0fTOr4oxl
         W5GNj6kSv5gxo4idFpsuBIjKDIZYPwcEmODHQ4U/Lm/9n60j4WX3TdxcaNaay6OO0Y72
         /mRX8q12wm4QUASjAixVQD2zEj0L3TrIyn2Pb2tVeLsB/uydjyT6QB9G6dcg6EfLpVHV
         bEt/Dq6Se/BQMUXIy+KbDLvcSGbDWBXwpCpU2VmZx3t3U7l29xUWv57pV88ycMaG+lXI
         PmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685753593; x=1688345593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HkWc440dWqKfJAoTPSU5D4E5Pe2P3uy3rMsCIhe40hk=;
        b=YinpO1eqHSci8cUKANqOZ48/qo48qf5cSUehHL+ZLz0/dNJvsLNXZlHxauHI0rOCKQ
         zfa+E6B3ItJUxig26cbWeq6t70jBHbGJBG5fxuJKv+h/4MFFSFnnx+0gnf+QCYd8EXTQ
         EjjH1O2m+O9D5ZbhVp3XlCDV0jpG/LFn659py43TIrN05TGUHlsqkbo4U8eSPQbGqR4r
         shmZGNYunXfEKbb0kehC71TZ1LPUkjeFwzKRkfL1a3dQHtWk5sur2Gj14Q+zIn6XBHXg
         +aYqqG70olIVThb8rrua7od/Mzg2REZnfnDbjzqG0oFGXZE0DpxuG0c9W/c9p/t8kFHy
         m6xg==
X-Gm-Message-State: AC+VfDyn2YlpxLAQ0n/0LsBUDcjHdilN2MiaGLvfZg1ErVI8xXxe9sFi
        nkfJqt2pxTL2lqH7qfeL257w5h07TAs=
X-Google-Smtp-Source: ACHHUZ5atE6hgPN+PIS7ryPhOEtiyjPljJzAD5UoyGoDuS1n9PY8qNGaaSv/DufvjeaNEn1FCcT4fsgpC4I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e04d:0:b0:bac:2448:2aa3 with SMTP id
 x74-20020a25e04d000000b00bac24482aa3mr1555079ybg.9.1685753592911; Fri, 02 Jun
 2023 17:53:12 -0700 (PDT)
Date:   Fri,  2 Jun 2023 17:52:28 -0700
In-Reply-To: <20230602010137.784664-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602010137.784664-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168574912392.1016815.8543067517884131468.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Grab memslot for correct address space in
 NX recovery worker
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Coatti <fabio.coatti@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 01 Jun 2023 18:01:37 -0700, Sean Christopherson wrote:
> Factor in the address space (non-SMM vs. SMM) of the target shadow page
> when recovering potential NX huge pages, otherwise KVM will retrieve the
> wrong memslot when zapping shadow pages that were created for SMM.  The
> bug most visibly manifests as a WARN on the memslot being non-NULL, but
> the worst case scenario is that KVM could unaccount the shadow page
> without ensuring KVM won't install a huge page, i.e. if the non-SMM slot
> is being dirty logged, but the SMM slot is not.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/mmu: Grab memslot for correct address space in NX recovery worker
      https://github.com/kvm-x86/linux/commit/817fa998362d

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
