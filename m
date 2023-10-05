Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB7A7B99CA
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbjJEBxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244374AbjJEBxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:53:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A77DD
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:53:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8191a1d5acso633789276.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696470783; x=1697075583; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=grrioV+IuPOlzeiTfMVLnMrxd2jdrACTo36YNzEpcnI=;
        b=LheG/L8tR+mfw5tleFKchGTEK8exwZv7d5ekYvwiKMcCBtpXbRzEzgyKgQCixbciHa
         2I8OpV+iXpVk4n+WTfqGr8nmOTVCvS8fQc0qSeH0Ll5hq+GgMfmy9NPQgSl2JMiawCqG
         DqcIJvMQZ1ImurF8/5/tShDrJbyxh8PMwluvYQQajVmbzGcpoLijQ0uarCkP+9sTm+ht
         2tL3/kUIKKptUB/68Gv2vRUi9lN5i1dmv/PF8zW5VyL8ABSSFEdTPGC0ximSuhTOYl/o
         tdr24MmsdWBMgQxMhzQzxbAzj11FCB7KG/yFsSrqtlpBY4OJdcMo8lnvK82EuD+VAYCw
         vP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696470783; x=1697075583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=grrioV+IuPOlzeiTfMVLnMrxd2jdrACTo36YNzEpcnI=;
        b=HYeWV4nA7j2B5T1vgLU/GoUbaNV/kI5w1RwKbJvKEL0WS4fMzMLLDU5WVJcKy2nQDx
         4gRE9QNmCduaO0oXmvtOXnsbQW7DMFR6ZWPBJXwIui6UhGBuhOqN6RaYWuY54fSgGwFS
         z4zbjoCpC20DhFRTfAZsaInWAoRtwTcuErSGBzLZZx9psDy4S9mWy8qCKKpn+gww1cuW
         83r+u+YhMt71hCcl3Z6xRu8GsEHhJNJZ+daG6Y1S/MfEFWbb7XxaUvnUEM1osBTspoX+
         MtG1HsYMI3887qlw2DMicd9hpyoMiS7WjVGusRX8xn1ITe887OHF/57hUYy7HdcnmrFH
         RmuQ==
X-Gm-Message-State: AOJu0YyssXrKrO5jrpVPIv5HtAEFSFP+zEhVn3yaIS9jqFJChJsHXIcy
        srnHz3Jx5B9zDZaRU2VOYlxh163I6/U=
X-Google-Smtp-Source: AGHT+IHyV4IRMorQjfEJtl3bCgO+6BZ9+2Q8anlpnWP+qXYS7Vaclmt7RTiW/s/YifIgopVhJqSKRRy92OU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ae52:0:b0:d7b:8d0c:43f1 with SMTP id
 g18-20020a25ae52000000b00d7b8d0c43f1mr60811ybe.9.1696470782888; Wed, 04 Oct
 2023 18:53:02 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:53:01 -0700
In-Reply-To: <20230908222905.1321305-6-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-6-amoorthy@google.com>
Message-ID: <ZR4W_c_dTHuKjB5q@google.com>
Subject: Re: [PATCH v5 05/17] KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures in
> kvm_vcpu_read/write_guest_page()

Why?  (rhetorical question)
