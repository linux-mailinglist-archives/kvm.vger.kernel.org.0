Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEA276D796
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjHBTRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjHBTRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:17:20 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5481731
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 12:17:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-563ab574cb5so82059a12.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 12:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691003839; x=1691608639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5AxzMJt2bPtQ5EtgIZk5VAn4zi3P8u/m47CM4UEy2c=;
        b=otyFsoOWrDv/6quxj7rv1dBisZkPIHW25XiWS61ikCc26s5v4I/9nBXA1oJjynx9qj
         jNIGL+Jz2jE4ig8tFtvgMRuYhMGJxFaot/Prin4LvEfpaaDSo1OLLbDNPX05jP0+LdD0
         RgD5OJ7OQcVmKydTDl252DSnJzMS8CXBkBhhkKummSxUw/gH0pDqJY08GezKCznvlAXK
         KhNVE0jTcz0QWnU4Nlp/b9Z9TgxuW4FYcsXLbp5m7yifdJS4fY3N0GmHMn4FWl8DpEmG
         pY8R3bIbhrc4agsPhXa6TukWkiOj91Kc3H/nUe4mIqPmaUBEH4xCf+RAYnpp6oNzqEYL
         nZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691003839; x=1691608639;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5AxzMJt2bPtQ5EtgIZk5VAn4zi3P8u/m47CM4UEy2c=;
        b=kdaKZD40Kkl44KrK7YkE6GX6DfcRXi6H4EM/X82+UEyfoPkQnKoSgcW9aiqbq6Ro26
         IAej58WQROPWyEYmIuipjexFnm75z3sAGxJvgvSfoE28h5bXismP4X8DdJqoij7kbdjY
         /aoW7mle/Qsy1hMiXabQe0SVaAE8xprOeT/JVIO2fAZVtZ8peF2GD940+QECUu7lhH+e
         98Yb23xB67m4PxmfVd29Wvj2N42fsfiYQ740OPek1C7B+zZeBQ+CS3b2lbehomydH9j1
         HYlNfeHznalpERwsysu8GbfKlBU4JrIoYsG2lhqQm79Av4lyV0gs5M0eycCPcUqZVD4y
         olrQ==
X-Gm-Message-State: ABy/qLbrZ8FoLY6NWBm7qFk3ES4OYrBnAnoQ9qrLLc1bXig3oVLEE7ot
        Zxc4b4SCXUy1onoWJMNx/jYEsQHBP2w=
X-Google-Smtp-Source: APBJJlEt3F1TDnvY60IyT+FoT26q8CLH3ut/dc5dW9pmDBlNh4ZY44w+hmm826e7yfostQ8cCFb9ZPlBkgo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2d2:b0:1b9:e8e5:b0a4 with SMTP id
 n18-20020a170902d2d200b001b9e8e5b0a4mr89849plc.8.1691003838751; Wed, 02 Aug
 2023 12:17:18 -0700 (PDT)
Date:   Wed,  2 Aug 2023 12:16:44 -0700
In-Reply-To: <20230625073438.57427-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230625073438.57427-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169084277743.1259368.2404878435563785686.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Use sysfs_emit() instead of sprintf()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 25 Jun 2023 15:34:38 +0800, Like Xu wrote:
> Use sysfs_emit() instead of the sprintf() for sysfs entries. sysfs_emit()
> knows the maximum of the temporary buffer used for outputting sysfs
> content and avoids overrunning the buffer length.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Use sysfs_emit() instead of sprintf()
      https://github.com/kvm-x86/linux/commit/1d6664fadda3

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
