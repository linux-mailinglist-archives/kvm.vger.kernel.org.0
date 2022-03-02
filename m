Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B674CAC34
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244090AbiCBRgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243824AbiCBRgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:36:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9401E50B1F
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:35:40 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s1so2151460plg.12
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g31Q1biXQsUkqLM6OlMOKrciBnbcEHw187r7e5y/1nE=;
        b=nfPeMMpreLlCLk6pctgBoE+lV6HQ28hwlJaIsDBe4v3XPZCakjX7ckna8IQeJPstiG
         TNS6rcflcJ26IeNA6LAh4tu8lV0Ul6TuEzVVv8MlvDdx96b+NV5i5UKvOOXNuRDGjBjN
         1A+o9Hf62ogU0BZ13H0YcnbLC0+eTVoQNZ9LAsu5srYNbI4pbcOmE85pss28cZv16UUJ
         Eby3tXZOI3TdMJpBA8/9IjcIsz/GU+06F8ucm4MR/wJ/YUoqfOtqGJHsMoPU5xIan0u2
         8QTmFxOGY/cBacGUBWArzsPGTQfbP/ntehlonC6oGAGix1jwmBSk846SX5CdcX4t40Df
         qaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g31Q1biXQsUkqLM6OlMOKrciBnbcEHw187r7e5y/1nE=;
        b=vcUKeK6w0v9m8UydCyn3H1C3vFkBVghoWOJrpFVf1F3XqikOLMoVmVCZcViiLVMZDa
         oIEvCs9HZVvZFQ/RQtxbEKjBZUAxVS8c6edAJ+O9IJTG5wiPdgHmTkEW4rrRWpVsG8/v
         JJgnZ3tz7MCR9vkjs7+2832JHuk7HGhehZ1S3ddRulQfrYnaSSBI78l5MTJpji0uV2Vs
         dJqVtOvGUDqR8H397Ac36AOwEdJlvCh5qsi318VDuB8G3IU5NTk0PhNbqbUQ0i3Tarjl
         dzTVLgpwJ5SOThe+DT24UUmIYruTjTxZYiAGXSVTJonbDBvNMVp6yMaPB0xGSMDjgyyG
         TUVQ==
X-Gm-Message-State: AOAM533jMrhZ8gj3elqiUHtq5qQ+p5HsgSsYNYWEaAEhG+WgtRg+GrLW
        TDS06RWMtbFFjpMGr/6KZYOG5g==
X-Google-Smtp-Source: ABdhPJzqVWJHtTMQXF6rGskQwQUZiWh6fplF5iBfjKig7T5aE4fZFMmORsWOVa1RKZKF8NgHKAQzXQ==
X-Received: by 2002:a17:902:8f94:b0:14f:d9b3:52c2 with SMTP id z20-20020a1709028f9400b0014fd9b352c2mr31616997plo.103.1646242539911;
        Wed, 02 Mar 2022 09:35:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n22-20020a056a0007d600b004f3ba7c23e2sm21740956pfu.37.2022.03.02.09.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 09:35:39 -0800 (PST)
Date:   Wed, 2 Mar 2022 17:35:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via
 asynchronous worker
Message-ID: <Yh+q59WsjgCdMcP7@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> However, I think we now need a module_get/module_put when creating/destroying
> a VM; the workers can outlive kvm_vm_release and therefore any reference
> automatically taken by VFS's fops_get/fops_put.

Haven't read the rest of the patch, but this caught my eye.  We _already_ need
to handle this scenario.  As you noted, any worker, i.e. anything that takes a
reference via kvm_get_kvm() without any additional guarantee that the module can't
be unloaded is suspect. x86 is mostly fine, though kvm_setup_async_pf() is likely
affected, and other architectures seem to have bugs.

Google has an internal patch that addresses this.  I believe David is going to post
the fix... David?
