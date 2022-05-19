Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D55852D9E2
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241820AbiESQKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241783AbiESQKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:10:36 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BCE9CF5C
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:10:35 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n18so5220126plg.5
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6P9aoIvTb4zsFevm1ytMUyd2KQeIyWHKWhq9w1IH5nA=;
        b=T7Cs1ly5aXcrAO13eVgUOej99XV/rj+jKzXmjsIRYzLGL6UcyV5iH3JPyRIq+djBCK
         xZwgz+2YFD4rDJcoJJQnFlzgl5yhdtM+Tl1MfQ7v8Umh9I3PJTj1hLvyRFkABe58SW16
         POlawmUVBZaIVFOqb03EeL2X0QGjr4FKdyMEBqsqx+cCqBgPbQd2WqMFBWGUqptRt32w
         0evGt3E/n5lZ3OVJ02QNqIJ1p70D3x8T91iRJ8RaPT4E00lNzMt5J2CHdvh9fFVGl8jU
         VsdQSylxiBaFG13J+J0ZdQH6LgQUAwamWicXRZXy+pudNkYL6vebjtHQ3YAn0pE3UbJ3
         W1wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6P9aoIvTb4zsFevm1ytMUyd2KQeIyWHKWhq9w1IH5nA=;
        b=bVfoNURgI3ofVlKRqFz9UpJtZ0sydXc5qBEs/fE86L/U9mtX28RBE8JHXGQCttRVQ8
         XFHFQJdXlqhMFnYfE1UJOGqVqvz8kOJ3Hvafx8LwMvifp4vkTtpr9LYhXrbzyKpJVfVu
         BKlxKjfq/l0GelStGTLqDvgQ9HCfQj2zo3UatDxJP4Wq+aZyspZIrzjVV6ZCP1YU08Sm
         P5myNW/DWQ4aIgt0zDOvh/wsQ6Ty6I3Qi0qAcMbHFkwKpJgsIoUu9QzCw7ou5+W27nIf
         JUMKiWzMfdwH/7K+5yAUITteNrIZn+wxwGdf7CQ1zXfzkFrYYpQe1vSWaqK8ge3XKllH
         n0Tg==
X-Gm-Message-State: AOAM532wfyu82QiVNDqtmZTAcRFgeg7/AaRjMD1B+j4R4oiK5mJbZC4q
        DuB8S4DTO44qv8SgqD7OEvi1bw==
X-Google-Smtp-Source: ABdhPJxDs1hTxUR5C4EzuM1SwmYr5BCL2DO/nb2Iv0FkQCnGAlR0Mez8mclqXftI71289BB5kbpqHw==
X-Received: by 2002:a17:902:7d89:b0:15e:e999:6b88 with SMTP id a9-20020a1709027d8900b0015ee9996b88mr5500329plm.98.1652976635201;
        Thu, 19 May 2022 09:10:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l17-20020a629111000000b00517d7fb695fsm4178516pfe.200.2022.05.19.09.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:10:34 -0700 (PDT)
Date:   Thu, 19 May 2022 16:10:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 03/19] KVM: x86: SVM: remove avic's broken code
 that updated APIC ID
Message-ID: <YoZr9wC2KjTFHrQ7@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427200314.276673-4-mlevitsk@redhat.com>
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

On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> AVIC is now inhibited if the guest changes apic id, thus remove
> that broken code.

Can you explicitly call out what's broken?  Just something short on the code not
handling the scenario where APIC ID is changed back to vcpu_id to help future
archaeologists.  I forget if there are other bugs...
