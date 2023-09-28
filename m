Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4017B186C
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjI1Kmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjI1Kmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:42:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41412198
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695897712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rF94+lxnXcbWAAeiKQ8ZfUkLdacuHhBSdWopelKLUFM=;
        b=D+rD8LaQ1Rvnu3OtFsLfpMPrwmY88hyv4uAZ/9po3W0b/avrPRWLh/F00hg/RkppZjoyAe
        eHreEx/SKa8Q9ih7+HzdF8GM/BZOYMTaSyw9tSHl/oxYz1weUcyjz+lqFzBg/2w9glWKOd
        bza2S36MVgwIME2hfyWYbNRwAytGoxc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-g-Y8mgrIMouFC1lwj1CM7w-1; Thu, 28 Sep 2023 06:41:51 -0400
X-MC-Unique: g-Y8mgrIMouFC1lwj1CM7w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5df65f9f4so114923785e9.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:41:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695897710; x=1696502510;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rF94+lxnXcbWAAeiKQ8ZfUkLdacuHhBSdWopelKLUFM=;
        b=soxMX4Tjb0LxP8rGpiPVoO3/PFoxKnKVzGMBqpvMnqk90IObzGLMFgsF0vay2RrmeN
         T6m0cMewuR7ZgpHJOrph42BtixCagiGDHMnFTyjKt4UfvlOESV+BAGIBtfI+WZCjXJUj
         Zuk+6QY/BjLR5dvPIqCK6t9Ydgup0BcoxRjUdH71KQXFpDMW0vTqax2Zfsy7te1sD8if
         9tkuQnVUihO8xSl4wDuvXCMcabZhVZ5R/rSsUJ343PsVm+Do0qUHUv7S5nhntGP2pDC9
         7IYgbSmgVUxzzTPOY8np5f/RHpthhy7rfKPzT4heyyAIQPALxPESPTsCZ7E6ueGDQI1x
         0hsg==
X-Gm-Message-State: AOJu0YwbA94T9J3X/z2K0tBocKD50U/yTgvPU8VODjPCJmDFhHpVM32n
        yiOqH+/S4PBu3zQCGa5rCwPbFIvsmRH/mfJ6CDjPbvRh5EqBu08lHBslv3QQD+WgCE+crSpj5QM
        s8yZNTZkd3Mxk
X-Received: by 2002:a05:600c:215:b0:405:1c19:b747 with SMTP id 21-20020a05600c021500b004051c19b747mr805046wmi.15.1695897709866;
        Thu, 28 Sep 2023 03:41:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4gD9DALZSJ4/eLzmtzbsiPAZcQA5nxTmweX88cLLeoiwUrPazcr8qIKWXbPPfoL1FOYaQSA==
X-Received: by 2002:a05:600c:215:b0:405:1c19:b747 with SMTP id 21-20020a05600c021500b004051c19b747mr805036wmi.15.1695897709537;
        Thu, 28 Sep 2023 03:41:49 -0700 (PDT)
Received: from starship ([89.237.96.178])
        by smtp.gmail.com with ESMTPSA id c17-20020adfe751000000b00317909f9985sm18923856wrn.113.2023.09.28.03.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 03:41:49 -0700 (PDT)
Message-ID: <50069cc01dc978f33c9196f91cd238d3307d27fb.camel@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: x86: add more information to kvm_exit
 tracepoint
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Date:   Thu, 28 Sep 2023 13:41:47 +0300
In-Reply-To: <3524fd5b-d846-ffae-0134-fef4447d8d72@redhat.com>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
         <20230924124410.897646-4-mlevitsk@redhat.com>
         <3524fd5b-d846-ffae-0134-fef4447d8d72@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-09-26 у 18:40 +0200, Paolo Bonzini wrote:
> On 9/24/23 14:44, Maxim Levitsky wrote:
> > +		__field(	bool,		guest_mode      )	     \
> > +		__field(	u64,		requests        )	     \
> > +		__field(	bool,		req_imm_exit	)	     \
> 
> I am not sure about adding guest_mode or req_imm_exit here, because they 
> should always match kvm_entry.
> 
> Paolo
> 

I'll drop both.

Best regards,
	Maxim levitsky



