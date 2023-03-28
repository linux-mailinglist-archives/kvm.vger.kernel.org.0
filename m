Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA926CB5BB
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 07:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbjC1FCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 01:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC1FCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 01:02:35 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603E92109
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:34 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bc19-20020a656d93000000b005072b17a298so2880817pgb.14
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679979753;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KkAskRRzdhC/bMNCa2j28DRM5C48pOHHooRUL4eCLk8=;
        b=n+5kHXVWwOWH1+OYBepw9jy0PBOyo4xD/lszV9vZjNBU5DBlImp8sc6GTi0UZSI4xv
         FSDYECkhcWs4B+IeawuxcOd077k7nOHdVPoso5I1pYRzH7MdWXLW2JaZOhneXJTwMyCl
         8xc8OFRuQj8sBlwlYxT5Setgdylt++MCi0+KFJ8O3KoFkjVtN/wvPCHYAW0m+vj1EoMt
         NsscX8z3TmjDUUvHNtuh/nQhMQvq717PE3N+3lbbp4D/eF4Q3v0Uy5UoQRRfEFtZu8KL
         4yz7y26MJ4kroInG4t12j6Bs0BkwpCQKb5laEjKA+JbTFPzbaX6S/rW1xFf592YHhvSe
         iCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679979753;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkAskRRzdhC/bMNCa2j28DRM5C48pOHHooRUL4eCLk8=;
        b=awVlrlAsNnPXHVu4LuyGTLmlx3uHaRC9DwzZW+q3R3eNeOH+FjDg/Le5yptDFkSYAs
         aO1sbHC5049wKFIp6jBvnma5VesiNT3sEYZkNKE0m/z6rsioyp83z1RLWFL4pB+jDFb3
         202jRbbIJoGDVv56SLvmbHgVGgzlnPchWPssRX/X7Wd0X6aD1lz5AufU0kKkxeXMPGmq
         HKEYmviQ3GAkZmbKsoD9V5bso1bu+uwBtOzpcdObSDcyxK/v+Aeo/a1KpWr+uNw6pdca
         J3Rj5RiVFDQ6J39KGBsEdg7V/EGj08wqUP4QdNoXVKIBNAdLISRg2YYFRzQo8/cH7x0N
         5tfQ==
X-Gm-Message-State: AO0yUKVANlfDD8zR8AWSN3esH5hOh+lZOmUKkQX9BL+hOc0kexOU7+kG
        5PyoJG/OG06N2qKQtCP0SV97LBALUJQ=
X-Google-Smtp-Source: AK7set8lZcaGrMdXH6dsc1kzS5ZohqOaTDdeGHxdrTHcgjPkn8C39jhRzya6TQvBTQ+Jy/v4X0asgsWvagg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:67d6:0:b0:50f:6926:ea7e with SMTP id
 b22-20020a6567d6000000b0050f6926ea7emr6050327pgs.2.1679979753691; Mon, 27 Mar
 2023 22:02:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 27 Mar 2023 22:02:28 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328050231.3008531-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/3] x86/msr: Add tests for command MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add testcases for the write-only MSRs IA32_PRED_CMD and IA32_FLUSH_CMD.

Note, this depends on the x2APIC MSR series[*].  Unless someone yells,
I'll include both in a pull request later this week.

[*] https://lkml.kernel.org/r/20230107011737.577244-1-seanjc%40google.com

Sean Christopherson (3):
  x86: Add define for MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
  x86/msr: Add testcases for MSR_IA32_PRED_CMD and its IBPB command
  x86/msr: Add testcases for MSR_IA32_FLUSH_CMD and its L1D_FLUSH
    command

 lib/x86/msr.h       |  4 ++++
 lib/x86/processor.h |  1 +
 x86/msr.c           | 38 ++++++++++++++++++++++++++++++++++++++
 x86/vmexit.c        |  2 +-
 4 files changed, 44 insertions(+), 1 deletion(-)


base-commit: fa1bddcf1565fc90b98f760358ff74d741fd9a2f
-- 
2.40.0.348.gf938b09366-goog

