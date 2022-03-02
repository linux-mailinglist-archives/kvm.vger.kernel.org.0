Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6154CAD9F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244456AbiCBSei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239962AbiCBSei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:34:38 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EB4CA0E3
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:33:54 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id j15so4276589lfe.11
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 10:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sd+QCgx6ejQtfJh0ZQLIdPUh9xzXsejItXGMffzQAc0=;
        b=iDSC1AseNmMqk2BqO7yCgINbNSucW1S3mrbiOcArZvBpaghKwT9l5hvk22nxxddJU5
         CVMLR9RINtqyWLOKbKAVHFgUwgywuLK4/rWM5ztyt8xGmslZfjnR4dqRSIiG1Fn2Gl3q
         CS9mK5K2Te6lc2kqG9LCaKpItlJRuZxE8k+zB4CJAh0caTvns3dHKn0bXI/xhruG9XSP
         veeOTiJl4mtTtQLfQs7kZrRjchr69XTyffiHes/ddzmbXoiYOWK7UbVIei2CjZc4x5Sw
         grg4R67/MKJZq2tKoKpTdubCvAwswmSciBb7SoZvjE3nRMILTxfSWCtOMZIscWIGO6nw
         mQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sd+QCgx6ejQtfJh0ZQLIdPUh9xzXsejItXGMffzQAc0=;
        b=w/tHlKzVWcR2kqinhjqk/Q6EyF48Mk+90wjpGaBIahBw+WWFVp1gMDzlFyIaL47X3w
         HKZ24+M+ffSnP17xgjdmARS4XSb880oDF1Lm/m/NddL+Hn9SpLaRMf885g9P9PsBwxKB
         dCOqtrpt0lwysySe7gK5aq3ne+Tlt2NirZO6ZmOimU++kE2NL3DO+BKDZyPz+VLUZeIl
         DjIIHX3/w3ApECGABXeNh2gnmz4ryyl7BVoY5S4DZ+UMzk5FKO3Z1PLLyZ4kr6prfpAh
         prSeXSBoYPBTbqeL4OosBJ/2E0X0MnJ9yRrHTE5m+PbARJlteIiGxOfrIxPIo7rNdoHu
         tcUQ==
X-Gm-Message-State: AOAM533y3XxGaT2CVpo4AbZyUQ5G/zzzouS2I5VVsfbPd6ltou0Ok+C/
        SUUBEdGPnSXB/OmjowCJxQWlrfJE6W/H2z5kSeZTDw==
X-Google-Smtp-Source: ABdhPJz3IXcAFe58DPhtDWnyKmNPxGvamwOJoWEhrYKhfFZTY7ccoweBqSbYNkziQsARF2nCSN+vas2mfKXR3PaNjhE=
X-Received: by 2002:ac2:5a5d:0:b0:444:26e0:3d6a with SMTP id
 r29-20020ac25a5d000000b0044426e03d6amr18336527lfn.537.1646246028875; Wed, 02
 Mar 2022 10:33:48 -0800 (PST)
MIME-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com> <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com> <Yh+q59WsjgCdMcP7@google.com>
In-Reply-To: <Yh+q59WsjgCdMcP7@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 2 Mar 2022 10:33:22 -0800
Message-ID: <CALzav=dzqOp-css8kgqHhCLJnbUrUZt+e_YStCj2HFy0oD+vGg@mail.gmail.com>
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous worker
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 2, 2022 at 9:35 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> > However, I think we now need a module_get/module_put when creating/destroying
> > a VM; the workers can outlive kvm_vm_release and therefore any reference
> > automatically taken by VFS's fops_get/fops_put.
>
> Haven't read the rest of the patch, but this caught my eye.  We _already_ need
> to handle this scenario.  As you noted, any worker, i.e. anything that takes a
> reference via kvm_get_kvm() without any additional guarantee that the module can't
> be unloaded is suspect. x86 is mostly fine, though kvm_setup_async_pf() is likely
> affected, and other architectures seem to have bugs.
>
> Google has an internal patch that addresses this.  I believe David is going to post
> the fix... David?

This was towards the back of my queue but I can bump it to the front.
I'll have the patches out this week.
