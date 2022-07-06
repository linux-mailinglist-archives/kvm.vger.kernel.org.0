Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AB0569549
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 00:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiGFW1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 18:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiGFW1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 18:27:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FCA2AE34
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 15:27:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 70so571509pfx.1
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 15:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8En5VcDzJpRZUJVBlGHl7Q0Kg1P7kPCrXjhE+LYfN5M=;
        b=kUIIVGCvERQEwyak3xqYOSlBxS1t7NuI8dhRO8VQaU9LIJ4OHWPVFlkNrzzG8/4+4h
         9bMaqgsk8h471N0EWcKC28ueATACcd427UQJ08RGW/XfwbnTa9KOCj6Gj5+JKtgkIYNg
         mV42Sjkr8T7U+CFhVFGY2RkyxyF1dHwogJs/8kX8bMg77uOzJehO6zidjkXV+rS4rx28
         aX5yARkMcygsr/w43e7dqgSElHUG8h+okUWK+0TP0E7BCzKWbPcwMXc08LxXEtzyKbNl
         9oG04V8LDumUHN+BuX8c1em1gW0L+Y2EwVQw3ihOm5eJlblVDdaqBA/R8rsisN0ySVGr
         ownA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8En5VcDzJpRZUJVBlGHl7Q0Kg1P7kPCrXjhE+LYfN5M=;
        b=I91g7H/sWUwcHiWPh2lzn6KDBy+pLlGASQlkk8zqhm0Dk2zx+kBi5rhjLmYHq39fc5
         2YppKlcJvXn6msxS6DTI8+Y8TWnxLid1xbUER3Pr5Rkgb+EK9oURtuUksUiNDAC/YHIN
         uivxX3paK4vWzy1XYDnjrY3AaXI87LokWqK8Q7pSX58P5/AlVQ5V4NZ44uYfebhlVBUx
         Dt7q+97ijWOuUq0swrtURJFmBPaQXIDyQeyVdaceVyjfAzEvn7wgOPxAp2fTJZBQkfnn
         9kK+VfLhVePe6mAlbVMeYWrahkyIBHAPxN3XgQpYvrm7L+45llE7gZo5ZwO7weNkFDQa
         BvAQ==
X-Gm-Message-State: AJIora8WKuKrSUFZ+UFOQ29xZ62yXvFUOQ6Cr1gFvjIEYAgtW9L8B1eF
        NRhIUuRbmmtKKll7ZCz8zkqBJw==
X-Google-Smtp-Source: AGRyM1vHvu+U2FyKN0UOsLIZn0q60hIVl9H32PwcOuMvAe5bhsFNxwgb8QQ+Rs8X2STgT9XFwF4Qyw==
X-Received: by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id h8-20020a170902f70800b00153839fbf2cmr49549892plo.113.1657146432846;
        Wed, 06 Jul 2022 15:27:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e17-20020aa798d1000000b00525496442ccsm25310656pfm.216.2022.07.06.15.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 15:27:12 -0700 (PDT)
Date:   Wed, 6 Jul 2022 22:27:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/28] KVM: VMX: Get rid of eVMCS specific VMX
 controls sanitization
Message-ID: <YsYMPCr3/ig0xPFj@google.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-14-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629150625.238286-14-vkuznets@redhat.com>
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

On Wed, Jun 29, 2022, Vitaly Kuznetsov wrote:
> With the updated eVMCSv1 definition, there's no known 'problematic'
> controls which are exposed in VMX control MSRs but are not present in
> eVMCSv1. Get rid of the filtering.

Ah, this patch is confusing until one realizes that this is dropping the "filtering"
for what controls/features _KVM_ uses, whereas nested_evmcs_filter_control_msr()
filters controls that are presented to L1.

Can you add something to clarify that in the changelog?
