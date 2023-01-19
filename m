Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729996743AC
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjASUu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjASUtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:49:15 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636C74DCC0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:49:10 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m7-20020a170902db0700b00194bd3c810aso1969027plx.23
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:49:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wig5JTFOOIWfDBvwzop4BGM09lRr5oKSEsYcvD8s+Ew=;
        b=Vs8DgSRo/Hm2B8p+NidYLeTpa16Qehx32yLSDW0+954JaNA0GDhz6qvhQQUT1DEPSv
         nWKZN3iXR1u7UaLbCa86kQrwxCLDIx9fj9wlnm04MLZc3oljIMhsaEs3yjKL8VyQA5Zb
         wEj8pky06xtHcplbdRXv+EWEwi9M5SohR6TcFtxUorT2DCvd5Hb7ApTVT6zSEiaCeCo1
         7Jg3SNa+IdEMUkPNgQ3fBqMHsnTmwNqC92XayECuvCxCNoeAeCFs7+KtoYi+B+ucRqAC
         AZXdJ66h9Tjk9qVQavJD3uAOJm9xGS65fYo6bNL/Mp/0fJjGetB9wgq+gdooBBKpl8il
         Le1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wig5JTFOOIWfDBvwzop4BGM09lRr5oKSEsYcvD8s+Ew=;
        b=1b6kt1ns4PeOz1Y0mVDFMPv70NPNphGcssEoIJ4jE2KQ6b6CN/ipevr3fDc/eChIiH
         RfVUIpYVLNjawmsQrvrGrLdzlGKPA9Sh5kqcSoltESVvjuUNj3ik/flJvE7jzHYXkT/r
         J5ujwue91qHkMrggbWeqTnj8mWEvNMDgGm+D07IAZcxxYtNhh7vDZjFaPbiytqW5UXkU
         Gz8ZsyRPl3Nh7u4OvbfsSA/NhewE2a/SVClhU9N4fuaZaMXeLPM37zCsUK+UiAkhJSbB
         PFHUy2Zx1/cRitVnbBqA1g+YqOpEW5QLZOFE/aa2FOYUWYoQV6W7kRFvXxpe4fak8dpf
         nK7Q==
X-Gm-Message-State: AFqh2kr0AScDD8NVD0OWxfSOfbnqi4bQRCxNeiPWbzZ9+ld4blONK3Ql
        wkth/cPdXint/Pj9hz4BfiTuc2hZE0I=
X-Google-Smtp-Source: AMrXdXv4r8SuXFkgvfUk09FB2lNK8u69IqS9MYYsKdrnsOV0eFIhj/mHPlicgBdI1CPiQMzFxUTwkUVq+Bw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9114:b0:229:f43c:4049 with SMTP id
 k20-20020a17090a911400b00229f43c4049mr6332pjo.0.1674161349507; Thu, 19 Jan
 2023 12:49:09 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:48:48 +0000
In-Reply-To: <20230105214303.2919415-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20230105214303.2919415-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409087681.2375490.6054601368040025297.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Replace cpu_dirty_logging_count with nr_memslots_dirty_logging
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 05 Jan 2023 13:43:03 -0800, David Matlack wrote:
> Drop cpu_dirty_logging_count in favor of nr_memslots_dirty_logging.
> Both fields count the number of memslots that have dirty-logging enabled,
> with the only difference being that cpu_dirty_logging_count is only
> incremented when using PML. So while nr_memslots_dirty_logging is not a
> direct replacement for cpu_dirty_logging_count, it can be combined with
> enable_pml to get the same information.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Replace cpu_dirty_logging_count with nr_memslots_dirty_logging
      https://github.com/kvm-x86/linux/commit/1799eb69b994

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
