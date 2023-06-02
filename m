Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF12E71F7CE
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjFBBZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjFBBZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:25:24 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51127195
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:25:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5341081a962so1474246a12.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669122; x=1688261122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aAeX2x25IEnYqDcyaaeygr5j/RLaW3VmX83LOkBX62w=;
        b=jbC28+Kk7+GbdZAD1n0cOFaoxamdpSTEFpFL9n6fWhGNd1eXtqCZy2GPO3UhLfuIso
         LuZVH1bk1JFiY6VmkOkHSSi653/6qASI6QLZfEy+l1C/wavY06zJ3PiiSblOYtplHFhY
         qpsSlMydNAkrd276ftCjEEKJi1Mc0C/EEKEA36lb5b9bg+CILb6fMxzFfnmG8MmClm/j
         erSCxIS8XEoxtisxmddOCQooO7I0zCsAw6TnFywGnDoOCDxHCRgRFLt0L2DE9SqJzkc4
         3nJ+NacV4wGU2jVrarcjaCoTLIhoystDqFgsTRU8dbZW5mF7io3jMH2SA62O37Fd/Dlz
         yVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669122; x=1688261122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aAeX2x25IEnYqDcyaaeygr5j/RLaW3VmX83LOkBX62w=;
        b=gTRqq/uy2x3gD2pg2tSrlw7NLOsx5qJvqsUF+IxPExmAUGTOzBwpNKOUOldKtIRZdO
         KMMv7USRbLQ7ZmsSDIZ9cDXEVshcGeuIAxhhshELxZu4zaArSLOu+pwtkAWWTxvUioch
         ajy7zZZPgaW/31nseowfJE98Sx8SuBXcQp6nvMBpXjT0GOn4NQD/uinEe/fSkCjaF1ob
         S6E+60+EUkywurnQAm2WBo/ntx1+SCJ9pgTSUM0JIeMI6EjHEKYOpWBprPek2mxTKrCU
         GrEgT1olKrpsFsa/cxetyuOKe8jC2yf/YDs4Rg9ryXLRKIW88vNxWa9r7Vv2KK7eHFeJ
         IM8g==
X-Gm-Message-State: AC+VfDy3R4uFA7qzrbkTkcsEFd0HNPHJxJv+Fm2rSOTniQStwRShWELt
        hawQ5o/fNtFf44zEu29QpZioM2TT1RQ=
X-Google-Smtp-Source: ACHHUZ6mdPKFdzG/VCK/fOCRl3UFXp7GQZZehhCor8qs5f4C1fSI7fJE390vyhN3BSJmeej6Dj75Gdm96tQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4450:0:b0:51b:2805:6d43 with SMTP id
 t16-20020a634450000000b0051b28056d43mr418215pgk.1.1685669121776; Thu, 01 Jun
 2023 18:25:21 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:23:36 -0700
In-Reply-To: <20230412200913.1570873-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20230412200913.1570873-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565340740.666768.10463587554285914493.b4-ty@google.com>
Subject: Re: [PATCH] selftests/kvm: touch all pages of args on each memstress iteration
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     vipinsh@google.com, bgardon@google.com
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

On Wed, 12 Apr 2023 16:09:13 -0400, Paolo Bonzini wrote:
> Access the same memory addresses on each iteration of the memstress
> guest code.  This ensures that the state of KVM's page tables
> is the same after every iteration, including the pages that host the
> guest page tables for args and vcpu_args.
> 
> This difference is visible on the dirty_log_page_splitting_test
> on AMD machines.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] selftests/kvm: touch all pages of args on each memstress iteration
      https://github.com/kvm-x86/linux/commit/07b4b2f4047f

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
