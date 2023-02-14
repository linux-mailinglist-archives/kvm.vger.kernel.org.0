Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E49A696BEC
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 18:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjBNRmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 12:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbjBNRmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 12:42:53 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90AEAD30
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:42:52 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id oo13-20020a17090b1c8d00b0022936a63a22so10692843pjb.8
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 09:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpOCg1lxpw0K+BuGz+WGampNAyAb84XQnWKu/NkN0RY=;
        b=IEII3ryXGaTsmPlox0H7PpAhkkSVbrdQooketGjK2YGWrYxcagHfVyGamgHa20pGxd
         MZHlk2dXjYfP1igtOLZsdca1s9HvcUmvFAcF9xQOiCqcDrDbg+RjDMAdI850xSNXnlcB
         Uj9nalCbBY5CHLNQDVdn2AdgNeBQ7Rlu0rQbeQM002suoehJOkQtYZ4rLoh9lXO7dR44
         3BNI2a+8O5vBDSDP1h1EbliQB/ZutxBzNzf40lCIIFBhA2DDMoJ4RSwwS7WKUEfrt+B5
         pI5MqQnWMHAFB56qQrKcFARd/u5ZuQF7ED29U351fxcGVFK6GBjoPxrShU5lZ5ti4Xpt
         cRfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpOCg1lxpw0K+BuGz+WGampNAyAb84XQnWKu/NkN0RY=;
        b=1kdQqLM5DDxZHkKXnWB3Jl0Fy1OrycChwROOnkepNBS4jcFgvm38Z9cp1naQslFwc1
         Vur8UYKHwRDh5HUKtnWDKUYmEzOQe7AVti8yEocWXCpsnwnPzF2BztbEPt3pcFqiKfxv
         ohGEt+yI3x+qf0fw3sxVIQORtoycsRIexREprTtLZL2ibjzR0l+WOzp3sUuXx+DqeA/+
         MX1uIIEtMOfhef4kmywHQf06YrvgBUQtVS6QPysmvvIFoziQSOBEBO87af5VBWRVhKGq
         N0/N89Mi46gjKapo1ne+Qp7MQQrnWN2Bj1FAaucDi/Gb7TiXLR9AeP7UcuDzif5Vj+KV
         MdZQ==
X-Gm-Message-State: AO0yUKWLgzY9tBLLWxJBLKCm0uCxKqiiICCG7KysZU5t4oGE0H9MPcRz
        u6F57lMrn77j2J2YuH5AVoUKBSjQmOc=
X-Google-Smtp-Source: AK7set9Z6Awwc+T/2wmSLLjKb0ywjpf7XGOl83rYeLgkAXBaicxPa824sDVclzkhc/GM8G6qKjl4Xh3xBc4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec87:b0:199:2069:7dfd with SMTP id
 x7-20020a170902ec8700b0019920697dfdmr943039plg.4.1676396572265; Tue, 14 Feb
 2023 09:42:52 -0800 (PST)
Date:   Tue, 14 Feb 2023 09:42:50 -0800
In-Reply-To: <85b3d348-2e4a-43aa-0131-27e9fc375cf9@gmail.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com> <20230210003148.2646712-9-seanjc@google.com>
 <85b3d348-2e4a-43aa-0131-27e9fc375cf9@gmail.com>
Message-ID: <Y+vIGskVnzMbfIQo@google.com>
Subject: Re: [PATCH v2 08/21] KVM: selftests: Split PMU caps sub-tests to
 avoid writing MSR after KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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

On Tue, Feb 14, 2023, Like Xu wrote:
> Nit, could this patch be applied before the relevant KVM modifications [1] so that
> a CI bot doesn't generate an error report before this selftests patch is applied ?

Yeah, good call.  CI aside, this patch should definitely land before the KVM change.

> [1] KVM: x86: Disallow writes to immutable feature MSRs after KVM_RUN
