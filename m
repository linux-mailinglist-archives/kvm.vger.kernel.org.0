Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60017622F13
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 16:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiKIPaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 10:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbiKIPaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 10:30:01 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB8812A9D
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 07:30:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id p12so11910806plq.4
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 07:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TyH6PCPcqORklSzFuL2oj5Of9WpvpNpPKZi4oJRbTRE=;
        b=NPBmJsQnxzo9i371l5izRpd0Ei00ow+pLaFscyiwl6lSIsok+xDVan4Bk6Ep//Ifig
         X97gqtYB9BW5y6iyzQVng+GKNV9KMlzRxdy3ZU8q2+4BU1jrTNiayLFMF1VKlorXraQ1
         5Yxam03VxU/4wo3Tb4NstPGkluvTMIM/iO8YhI9+/oMPJ92umY7qg3UKUSoIo+72QWUI
         zQF0t+lNHkTxNmdc7uBwSHJKMI/89MOJE//px5WkIdKNmdf8oZ+sn2L0UDcDtgo15/4q
         x9K4CrZDI6weDhZ420da8RILG0LXhCgxPHbDUyswhUG+CoM51lPcfHXURbZW6TetX0va
         6Gzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TyH6PCPcqORklSzFuL2oj5Of9WpvpNpPKZi4oJRbTRE=;
        b=chYFC0AADtJ+BE/r4JXDLtPIMu6qV3ELu/W1nQLwo04lBRi1xPmdxIiovmHColuGAX
         gRNDZKehWflUwd2vGch8b9Cv9FBkKn/N3N+FW1ozrilKTywmOQk07+DriKCPP2LSudGB
         WdsP0mkLpJwxjpmAM8noXI9CR4C2R0pZcN/HcPlEKEbP2uCboWIR4HsoUavMQxCWqzY1
         +xAYAD6MEuUXJnVAKoOlCguQqX6WWGlBzH/6OynHgLOIk7XCkhJ5nvspBYXWvQnKp/m8
         7j1sNNdmQnSFNpsRiFDSIWyVO1XDUlNOZICWOoi0N0pyNW2xZZsPv0JlBw3u5yYI8vH7
         mCiw==
X-Gm-Message-State: ACrzQf2vnwab/e1YF87ZJOgJz8hhCykzKCyMiQIkF2hAVDVwfGYKhUd/
        2phWbhPjll3baQx2k8q4TEEFYA==
X-Google-Smtp-Source: AMsMyM5EN+cPdXDFJ+x16060SGfZpiGFilX9cNkDwCPun4FE4PdhpfKEtN/BfWedMDjFfjw2hC79rQ==
X-Received: by 2002:a17:903:2645:b0:185:480a:85d2 with SMTP id je5-20020a170903264500b00185480a85d2mr61719725plb.144.1668007799728;
        Wed, 09 Nov 2022 07:29:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i4-20020a63cd04000000b0045751ef6423sm7706405pgg.87.2022.11.09.07.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 07:29:59 -0800 (PST)
Date:   Wed, 9 Nov 2022 15:29:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thomas.lendacky@amd.com, jmattson@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 08/11] KVM: SVM: move guest vmsave/vmload back to assembly
Message-ID: <Y2vHdMJiFrZNSJsB@google.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
 <20221109145156.84714-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109145156.84714-9-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 09, 2022, Paolo Bonzini wrote:
> FILL_RETURN_BUFFER can access percpu data, therefore vmload of the
> host save area must be executed first.  First of all, move the VMCB
> vmsave/vmload to assembly, essentially undoing commit fb0c4a4fee5a ("KVM:

Nit, similar to adding parantheses to function names, I prefer capitalizing instruction
mnemonics, i.e. VMSAVE and VMLOAD, to make it obvious that you're referring to a
specific instruction as opposed to a theme/flow.

> SVM: move VMLOAD/VMSAVE to C code", 2021-03-15).  The reason for that
> commit was that it made it simpler to use a different VMCB for
> VMLOAD/VMSAVE versus VMRUN; but that is not a big hassle anymore thanks
> to the kvm-asm-offsets machinery.
> 
> The idea on how to number the exception tables is stolen from
> a prototype patch by Peter Zijlstra.
> 
> Cc: stable@vger.kernel.org
> Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
> Link: <https://lore.kernel.org/all/f571e404-e625-bae1-10e9-449b2eb4cbd8@citrix.com/>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
