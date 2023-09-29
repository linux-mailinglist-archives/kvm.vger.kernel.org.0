Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01327B2A48
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 04:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjI2CVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 22:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjI2CVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 22:21:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AA2199
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:21:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c6147ea811so99545295ad.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 19:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695954073; x=1696558873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KqB2vwg4zMsQYk4N0zMQ9SP3zDU9LWqIZau5o5KZ8lM=;
        b=GmIWYl3DR7f3RDzE4GiE8fPjT9+vl98BLrwD9h8AqXck98ysqiSntqcdSpzgNJpexl
         T+nmKa8e6YdfZSVP67niVgZ6sTEfd4SGgwWDRO7N2ZOXqY0242L2/f5F2FsvQqsdI3ca
         kPs1yR03JDxSMNFF+fepT5xbot+/LSIXH++TiUIxh2qvX9dAweAdXFlQCHpHifQxYiZc
         lJhAe17cZ0qeo2nsQPPld6jaUpc7Y26aUx9CYkABSff+RzwfMlFey/KT74olpMyD1m7q
         lQqn349hLbtIsgdnW63FadmWSX9R8uwxh7zuA2n4HhKLgWq4uXFYVHSlxV8DjlrIlfUE
         ml9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695954073; x=1696558873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KqB2vwg4zMsQYk4N0zMQ9SP3zDU9LWqIZau5o5KZ8lM=;
        b=qe0wIrU99nuL43H3jura2tt42Q9c08H7RRf/07P20QUuvdgIdnxy1MN1TLhQMiORhX
         YCg/ktwrS59+zrnALM6NN7udU3Y8T9ibaIAxcpKTgC9TGasB01Eo6LWt+OyGPLhkz5BY
         rUSQnhircSpvJaITPvl1azWdel8WGmGBktV0BPnRATI/GfkUCcn6XLPTJxo7bCQCm21y
         s857xCpF6MVwTVsMV6AAMnO2aC9NtAsllRDl0Rdvp7JZzOUhVBFAI1q9EZrfDM8vCxEI
         9FwQc3cZliELqoI8TVtHY2mBkfP/9B20+yZQZs0RNY5j+LAgJJMooCt/d+fI2qMraut3
         xAWg==
X-Gm-Message-State: AOJu0Yx/jwcAPPwZMLYw8K2fWC0jpGLT3OohoXN+whrvUX6hkr8D946q
        NHT5X6s5zrrEJJD5o6w21hMQ4JncqV0=
X-Google-Smtp-Source: AGHT+IEUl6xKMpm91wNEYp7KZx/XSzOQdDgdqEDqEY0DOKH3NZPNBy1EMHj+cD61B8bTospZFZi02jtctb0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cec7:b0:1c5:a121:f1b1 with SMTP id
 d7-20020a170902cec700b001c5a121f1b1mr39188plg.4.1695954073372; Thu, 28 Sep
 2023 19:21:13 -0700 (PDT)
Date:   Thu, 28 Sep 2023 19:20:03 -0700
In-Reply-To: <20230914055504.151365-1-tao1.su@linux.intel.com>
Mime-Version: 1.0
References: <20230914055504.151365-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169592345828.1074579.492958226763917510.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Tao Su <tao1.su@linux.intel.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, guang.zeng@intel.com,
        yi1.lai@intel.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Sep 2023 13:55:04 +0800, Tao Su wrote:
> When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> 
> Under the x2APIC section, regarding ICR, the SDM says:
> 
> [...]

Applied to kvm-x86 vmx.  I dropped the TODO and replaced with an explanation of
why the "extra" write is necessary, and why trying to avoid it isn't worth
"fixing".

Thanks!

[1/1] KVM: x86: Clear bit12 of ICR after APIC-write VM-exit
      https://github.com/kvm-x86/linux/commit/629d3698f695

--
https://github.com/kvm-x86/linux/tree/next
