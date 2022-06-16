Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324FF54E8EC
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 19:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbiFPRzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiFPRzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 13:55:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438C84CD7A
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:55:04 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id g8so1845698plt.8
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=znTRAobDR4k3IwStvUThGro3jde2RH7vgiXC22e3Wpo=;
        b=JtJ0/KXAoeyH22qk8xgaNmm6N6OhoBLl4osAVR1/dR3KcoInEdblt2EaO6bvp+9uKJ
         hXYKg6ygtQKIT4Iwn1DnlF3ejZO06HofaQGdM6Tun6+BhWMwzBvUDbYLJnjXxN6Vj0nQ
         XC7PQcMmL3vgm7FlCA37iYaJH6uuRmP7sSWrss56xUCUB6xWMzo7mlD7ajqkHtbrdQuW
         ZGPfWQtIhLwVwOPKyD8C1LtXYh0v4cOUGuAz2VDBaPkd9XKjl8STYU+oMlsHbScFSObb
         6s+65VdLGf1SzAnVV76C0iKDWDSe8Mj1FChNlu0FpbMY+jZ/0bpc8KClkBsN5dJ5X1Aj
         pCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=znTRAobDR4k3IwStvUThGro3jde2RH7vgiXC22e3Wpo=;
        b=crI7J8LdDG/dtRxu99JJJB9kblSCuSbtu7J8ClIe9Bq/m2vbM49wu/stbsCbufBNCW
         L43s3QH+c61hsyoQA7AVPhDyKVCJ+hVlw1WV/JQsVgJYFt9Cagzx1EgrVaRHfIXcXbkN
         IUHf0hSTAh8OPVzdSKS7Gp+U63y4Zqv8ab9NGzCNLbspZMIjQBdkehlBNiUOZmViJ8Az
         xlEhuI3JP98tNkRx5wwfPelkv5JNZW+IvhF/cTpx6Vbxea+GTIWuYPvP3l210j0eV/43
         o9IbjuY5yZXkzs5dXTM60l30Mq+mw4MEIKAYLKREmjzi+VvDQ1urqocoWkB3gzrF5oD0
         25Vg==
X-Gm-Message-State: AJIora+OeNlIUyuAP5RhgQihVSMLYRvw9KmjX5kRp21yPn5uhOS6xVf3
        5UIEexc8oNS9BUR3560Qyc6JOw==
X-Google-Smtp-Source: AGRyM1uhOKQUCAIvFL30Ds5lZ2ml2mbY1gKVVmgrKzfeoo20zsOX1T8ZhrFZWmE+OtQW3iTaoeA/Cg==
X-Received: by 2002:a17:903:41cd:b0:169:9b8:36a4 with SMTP id u13-20020a17090341cd00b0016909b836a4mr2988391ple.49.1655402103568;
        Thu, 16 Jun 2022 10:55:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 72-20020a17090a0fce00b001e310303275sm1827652pjz.54.2022.06.16.10.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 10:55:03 -0700 (PDT)
Date:   Thu, 16 Jun 2022 17:54:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 3/5] KVM: Get an fd before creating the VM
Message-ID: <YqtuczDtxhWp4R3/@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-4-oupton@google.com>
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

On Wed, May 18, 2022, Oliver Upton wrote:
> Hoist fd init to the very beginning of kvm_create_vm() so we can make

"init" is a bit ambiguous, e.g. from a "can I use the fd" perspective the fd is
still very much not initialized.  Also, it's at the beginning of
kvm_dev_ioctl_create_vm(), _before_ kvm_create_vm().

  Allocate a VM's fd at the very beginning of kvm_dev_ioctl_create_vm()
  so that KVM can use the fd value to generate strings, e.g. for debugfs,
  when creating and initializing the VM.

> use of it in other init routines.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
