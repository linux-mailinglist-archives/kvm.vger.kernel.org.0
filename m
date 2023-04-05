Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FE56D8AD7
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDEXBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjDEXBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:01:44 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC8155A6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:01:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 126-20020a630284000000b005135edbb985so9562100pgc.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680735703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mUjI/1fgdw3UTrWYJtNma0vpX4XnclWAvIY9tUjbgXI=;
        b=QSjL1SykZiGVT/931VKL9xDx+OBpwZAXuh8xsLXHdzgP8SzM9MwXNPAKNULpRt7nSs
         A3WBUuWN6z9zh7jY260XGW9PfG9PQtU23ctJfjxt70/VeiURFUTJpYw/X9Vqy2w2+J+F
         zPQyVwddCYp2TgyDIqQAKHli3hj011tmwimNTTL3A+xemSlGtq9P6idLG7RMs7rPDduE
         aJAcbC177bNmkMPD9RJAiHElJ33JwEnWq3Q+gigg53Qa2sNH68R0qO8/AvI9bzS/Dbkt
         NUZ0Qt3EmlIkzteTa2/z3vf/vkSakKQBjWLQEuv+r15XeDCCHRC7+WfuvKFa/uW/M1ca
         hnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680735703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mUjI/1fgdw3UTrWYJtNma0vpX4XnclWAvIY9tUjbgXI=;
        b=Mn41ccKFgBsMxwMCkJC66IGWMUHkFNAyIa6iUshb90cefALSmJfAvun2wSvf6PLpIP
         Dhiyir5mNR1MuQK6IxpXMM+2Oa7TlMy5Gd70qlyUoOca8VQvWQWpn0DM6jkSAWi7iRXB
         5m0+fxyf7pRWZmMtgsszNHnFV4UOuS/H6PuOQO59gNqhW6pJO5ndl4YVsArLtdAObOHU
         cKEwiyI9td6nCVMajMCCK25ZMCplPYFkyJUAUtiOns6UfYVLCjr6VeGnRn1u29XYMYit
         lodiFECdDLIWPduZdvcVAO6FZS5cpQ3X30382+HE9tpqxhfK48F9lBFqy+GCUaNDzr6r
         SuQQ==
X-Gm-Message-State: AAQBX9fhY/NV5xneoKYN9wVOd248DXrICUFu55ExoplTvdFLJop5ghWd
        ulNbs3ZPT9Fs77K0EIDJZgPx3yAvevE=
X-Google-Smtp-Source: AKy350bpygRzYXXUhTrwnEoSHHXMiIoLgqaQ+jdyq7SdDN6leOzhL/qeFGXtYam2SklyF8vfNkiCZhj8YLY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3589:b0:240:d397:e66f with SMTP id
 mm9-20020a17090b358900b00240d397e66fmr2929244pjb.6.1680735702935; Wed, 05 Apr
 2023 16:01:42 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:00:52 -0700
In-Reply-To: <20230126013405.2967156-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230126013405.2967156-1-mhal@rbox.co>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073532417.619084.1396428660986024437.b4-ty@google.com>
Subject: Re: [PATCH 0/3] KVM: x86/emulator: Segment load fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Jan 2023 02:34:02 +0100, Michal Luczaj wrote:
> Two small fixes for __load_segment_descriptor(), along with a KUT
> x86/emulator test.
> 
> And a question to maintainers: is it ok to send patches for two repos in
> one series?
> 
> Michal Luczaj (3):
> 
> [...]

Applied the KUT patch to kvm-x86 next, thanks!

[3/3] x86: Test CPL=3 DS/ES/FS/GS RPL=DPL=0 segment descriptor load
      https://github.com/kvm-x86/kvm-unit-tests/commit/05b0460e7f29

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next
