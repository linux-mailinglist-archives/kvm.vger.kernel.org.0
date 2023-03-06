Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35CA6ACC17
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 19:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjCFSLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 13:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCFSL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 13:11:26 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD8E6C680
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 10:11:05 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536bbaa701aso109860117b3.3
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 10:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678126262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WRzUZOUOR0F5iEyy7OYzk/PFh6SqysDfNWQDSV2r8pM=;
        b=LGVXNA1YxHWrHutK6YcXKA5mBHmmH6EZQWqVPNCMC7sL+nhYYzR3qfLY0yEYUjLESp
         BjxxOzulJ6OEIPqbXK540jzZLuhzwNLpD/zZbMYWXSV13h3lXsYXeV9pgZT4s0hO/wBX
         ZZw/bS5HVst6kACLTqyBCBzJKeaMFxVLzj1BPKVkSlI2gXg3r6hE8Anl1mDUU9stGHwX
         KzSj42yB/4FxYFAOhnjBuxO5znjH2ScMGwgc4CaTEjthCcxEJsVeyZv92H3kC2q+HUts
         6SEHjEvbZsX8RVyqLE94NGv0GepIgf97cXOd5d1J+ZTjxAQJlUyH9R9aBNoUUUSOBOYT
         9seg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678126262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WRzUZOUOR0F5iEyy7OYzk/PFh6SqysDfNWQDSV2r8pM=;
        b=5XzwivVZNtift+53lTPg6OldjWCz3RfAQy5HJM6kjHYkrzAITpbywEIEy7gWi7Ut0L
         Kn4diybh3XDyBOpTvvK60kpsXHngQCeTYTL+tgdHQEupPGe6Y5JAQJVpUxlO59q/bAVu
         Bi1MBrdhBI2ZdoFV/ZgBJh/pBuQ6a3ZQHbJh3+yui7y8JcxIM0LjqPFBOec1JZE3X5Ls
         VWC98zUknOleKRQEdXCPzPkoCEv7vVT8lCtzAlyZvd0w5Dklv0dAMiUr3EoA1+fPi8Kk
         Th2HzPGwvc7s3I4Kuh97yCXagUum0wLgd5vvnG5PuAbvy14xegoDwDqUmsbs9ZWlfJ0M
         aFIA==
X-Gm-Message-State: AO0yUKXKzSUsUvzsKzm/xvsiSKeF8wQhdsc6kSLPEkkNEpgsEz+52nSA
        ytqnGJOwflMSMT3iMPsniKc/Vb0GpTw=
X-Google-Smtp-Source: AK7set/uu0xeK+Pas9WlWG4VXMkfMen+myXsIokorGyccnSOO3RZPpOrS7iqFAAmyrXYSi2Vg98JGJeO4Wo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:145:b0:afd:2ef2:33c2 with SMTP id
 p5-20020a056902014500b00afd2ef233c2mr4888561ybh.2.1678126262033; Mon, 06 Mar
 2023 10:11:02 -0800 (PST)
Date:   Mon, 6 Mar 2023 10:11:00 -0800
In-Reply-To: <20230302052511.1918-35-xin3.li@intel.com>
Mime-Version: 1.0
References: <20230302052511.1918-1-xin3.li@intel.com> <20230302052511.1918-35-xin3.li@intel.com>
Message-ID: <ZAYstMn9mwPS5hOT@google.com>
Subject: Re: [PATCH v4 34/34] KVM: x86/vmx: execute "int $2" for NMI
 reinjection when FRED is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
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

On Wed, Mar 01, 2023, Xin Li wrote:
> Execute "int $2" for NMI reinjection when FRED is enabled.

This needs an explanation of _why_.  And as requested earlier[*], please avoid
"reinjection" in this context.

[*] https://lore.kernel.org/all/Y20f8v9ObO+IPwU+@google.com
