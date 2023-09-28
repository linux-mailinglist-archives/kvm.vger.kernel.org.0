Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3E27B186A
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjI1KmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjI1KmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:42:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF433195
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695897696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ujY5ssiz00Acvp8rMGRHNHWIqC+q9jsSl4olj7QYH/0=;
        b=eRB8u8/mdOiF0R/MHDZCYNJIsOYIQC8mJAm6Pf4QCEpJOgmBkkSBPJhK9LNKvlNgGyxOuB
        5b1Eckk9T8o9DDPYT+ZLoISbkud+Vof9a8bcK8WWVY5uBpJyKM3DmSab1Qlou8fEGrED0L
        LwnTuZIcdotCoGBjFcBP2Bfmq1uqhNY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-aC0GQM7gNua3agP1FA5VqA-1; Thu, 28 Sep 2023 06:41:34 -0400
X-MC-Unique: aC0GQM7gNua3agP1FA5VqA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-313c930ee0eso9788125f8f.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695897693; x=1696502493;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ujY5ssiz00Acvp8rMGRHNHWIqC+q9jsSl4olj7QYH/0=;
        b=s4sA7qLguIrZf2VxqESlmw5ZYEvR7oZyy9db7tDsXYdF/Lq4/FO8OwoN/4+eOMTxdj
         kX7m+ab0W7ZeknW3aZhfzmsxaYUux+/hB7v87c7unhY6/tXVljn/QSri66FWFkWZmTnN
         oPjUmMjZqWSXLARdcT6+4EFbMrBKY/7IMwDhUmGulcqd3z1Cr9+jwobIWDuc5py7pf4D
         pev2FhegOqF83BBVAmnzrVCB6KGBCzwkCG7wBH6FiPNdJC60kNFvvUapeCq5GwkazvOi
         12Cq3TNFuU387XqKhR0FRaXfbrN93IwYlZyh3JuKrmiyUDcCyvM5xJ9LZWr/9fICA/0j
         3QfQ==
X-Gm-Message-State: AOJu0YxLw9Buna3kCLWtOt7Cjgq4ou+8qFvvKQWvP1a1Q4CQNpvhqpdD
        F1Fz40DKtQNPsQTiSyg68BB1tsK1+hshziyfX1zi+Q58e22yCmuxRt49TRbtO4nKXOis66YApTD
        7q/RW+kOZlbF7iberh/0F
X-Received: by 2002:adf:d4c2:0:b0:31f:fafe:a741 with SMTP id w2-20020adfd4c2000000b0031ffafea741mr805287wrk.67.1695897693341;
        Thu, 28 Sep 2023 03:41:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8wQqJcLWfnLgcx3NFwWByEI5vHLz4X4Dd/wyS5mYLcYBquvQCsnqouz8WVv4GxVhZ3/cOTg==
X-Received: by 2002:adf:d4c2:0:b0:31f:fafe:a741 with SMTP id w2-20020adfd4c2000000b0031ffafea741mr805266wrk.67.1695897692989;
        Thu, 28 Sep 2023 03:41:32 -0700 (PDT)
Received: from starship ([89.237.96.178])
        by smtp.gmail.com with ESMTPSA id o11-20020a5d4a8b000000b0031fc4c31d77sm19261478wrq.88.2023.09.28.03.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 03:41:32 -0700 (PDT)
Message-ID: <43a47609b43641bd74f96d86783f984295e3d87d.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: add more information to the kvm_entry
 tracepoint
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Date:   Thu, 28 Sep 2023 13:41:30 +0300
In-Reply-To: <27053c89-e11c-e16d-ef88-89b3cd99c487@redhat.com>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
         <20230924124410.897646-3-mlevitsk@redhat.com>
         <27053c89-e11c-e16d-ef88-89b3cd99c487@redhat.com>
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

У вт, 2023-09-26 у 18:39 +0200, Paolo Bonzini пише:
> On 9/24/23 14:44, Maxim Levitsky wrote:
> > +		__field(	u32,		inj_info	)
> > +		__field(	u32,		inj_info_err	)
> > +		__field(	bool,		guest_mode	)
> > +		__field(	bool,		req_imm_exit	)
> > +		),
> 
> As anticipated in patch 1 I'm not so sure about adding req_imm_exit here 
> but also (especially) in kvm_exit.  I do believe it should be traced, 
> I'm not sure it's needed in kvm_entry+kvm_exit as opposed to just a 
> separate tracepoint.


I will drop guest_mode.

Best regards,
	Maxim Levitsky


> 
> Paolo
> 




