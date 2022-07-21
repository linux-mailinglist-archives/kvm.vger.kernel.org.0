Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4460F57C9FB
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiGULwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiGULwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:52:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B50E8322E
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kwcu/6jioYC6fESk86Od43i9Yz4XnMzrxYAr7rGMUf0=;
        b=UufAkK+94P3DmuQImu/Im321qLJd3NjAlCkzjpj11HM1ZEb63rR5Ri9xIParEyXwEYNkWz
        VQbZG9ula6bwBbEssoyaWaYbXhrW4+TRJXqDJb3bcZqhOrpACKI1g41kUBwNEHb5hzLj2A
        sLoPPI6hdWADiFdHNnyKkPPR+nhhJPI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-p3HKVR-iM02IYJH7o3thIg-1; Thu, 21 Jul 2022 07:52:39 -0400
X-MC-Unique: p3HKVR-iM02IYJH7o3thIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92EAE3C0D869;
        Thu, 21 Jul 2022 11:52:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C04403D0E0;
        Thu, 21 Jul 2022 11:52:34 +0000 (UTC)
Message-ID: <cc7af87817b91d1865b3847c92f748d2a2966f9a.camel@redhat.com>
Subject: Re: [PATCH v2 03/11] KVM: x86: emulator: remove assign_eip_near/far
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jul 2022 14:52:34 +0300
In-Reply-To: <YtiVH83GZwMkSJP1@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-4-mlevitsk@redhat.com> <YtiVH83GZwMkSJP1@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-20 at 23:51 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > Now the assign_eip_far just updates the emulation mode in addition to
> > updating the rip, it doesn't make sense to keep that function.
> > 
> > Move mode update to the callers and remove these functions.
> 
> I disagree, IMO there's a lot of value in differentiating between near and far.
> Yeah, the assign_eip_near() wrapper is kinda silly, but have that instead of
> a bare assign_eip() documents that e.g. jmp_rel() is a near jump and that it's
> not missing an update.
> 


OK, I'll drop this patch then.

Best regards,
	Maxim Levitsky

