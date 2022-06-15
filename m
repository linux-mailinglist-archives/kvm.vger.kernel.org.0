Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C389154D3BE
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349595AbiFOVbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 17:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347897AbiFOVbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 17:31:14 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F5C562D8
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:31:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r5so5823756pgr.3
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 14:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XJuTtRboMAs9N8ktAMOKiSjB9u8x15BH2R8IRWsSTLA=;
        b=WBmxK2TVhZ65xiZjJYPjbVXQNXYMUCA80p1fVmy3YIO1rki7OA9rQoK8AFbvYHQIgJ
         2lnzIVR3VFHk8eZtawrzFa6jNIjy7Mq8/23mils46pweJsQgEdhdEz6Zn1Kfkm9WjtmO
         aUZRBjYp+A6xThUOq5NvjyZV7DohsWk1sY60BX4e21Zi2QjMhamaluD0Gr6G090U30hy
         GOshubwCmaQIZ7wvl4wRCoIVTH3JasCbwNTT9kWqok+om9mLKHmUH7P42k1CzDz8bTgX
         pX9f7A18Q60ewh/UofVbnlp4gK5wiGVD/obBo2pObOyeDwJHipabGLgz/YlX2vZAJ5aq
         ewFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XJuTtRboMAs9N8ktAMOKiSjB9u8x15BH2R8IRWsSTLA=;
        b=GH8MwFKFj0W6MMS0xUwmwRlyqTzJJO4nxooNr7lcRE9uMAlCAb8+521lmmLSWMtfg+
         D8aZ9ztcFOh+aydJLJBvdIukl/J4YuCAMMM1Zcms+5lqnxAdLOWE+plDYOeKCIecidtT
         VN73kZQ/uYxW3NEnKjhAEejaXuxkjiOod3GDiH7Z1OhqzXW5T5AfAChjxexLM7n20GpO
         RqnoXaxT25ckAwvkVMFzgElkTxpimeqfw6ESNJd3mh2wM946VYhQ52dR5YAKo7OysJ+D
         MdilyfQMBqzPNqWGWI6zDAZQ2p6U/DSoSMKCx9MThgSf89JmYULJgCdz6BWWcOyoMxw+
         ZM1Q==
X-Gm-Message-State: AJIora+YmybQA8tMKf8guym/LOi+cFTOYBY8vYKeE3vE4BykvThyViJ7
        y8yHWN12q4U1bmrPLIWsBVOKgpofoDsFaQ==
X-Google-Smtp-Source: AGRyM1vDVQI22iYNU+4MJQ4BAhmbuPwj2hoWVXbKTSPdGrzB9TvUNcPvtiEHtujFPeLTN1aNxDJ7JA==
X-Received: by 2002:a63:f506:0:b0:3fc:962b:6e02 with SMTP id w6-20020a63f506000000b003fc962b6e02mr1547581pgh.266.1655328671853;
        Wed, 15 Jun 2022 14:31:11 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id je11-20020a170903264b00b0016223016d79sm94813plb.90.2022.06.15.14.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:31:11 -0700 (PDT)
Date:   Wed, 15 Jun 2022 21:31:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 02/11] x86: Move ap_init() to smp.c
Message-ID: <YqpPmz2SUP5nsUL+@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-3-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426114352.1262-3-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Varad Gautam wrote:
> +	printf("smp: waiting for %d APs\n", _cpu_count - 1);

Oof, this breaks run_test.sh / runtime.bash.  runtime.bash has a godawful hack
to detect that dummy.efi ran cleanly; it looks for "enabling apic" as the last
line to detect success.  I'll add a patch to fix this by having dummy.c print an
explicit magic string, e.g. Dummy Hello World!.
