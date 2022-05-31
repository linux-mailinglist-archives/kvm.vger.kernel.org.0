Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FED45395D8
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 20:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346810AbiEaSGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 14:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346797AbiEaSGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 14:06:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7577A45B
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:06:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d22so13522551plr.9
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XciBGloNFkqP//Xq+ttF70FZdl5Su7EofdD4Aed5eEs=;
        b=HweEQVKwlNonlo0R3Mf+sKBBGaDtbcYflMHKlz8JHgg/G0eNxCeWxkp/HlitiA5Lih
         dga0ZFTEcJgMvMAEx8xhZLy9IPC7Vihd3iFcdjyqWEOLk2P8q99faSoXfwTF8YmPe4++
         0bjGSWTIy0ppTCmEX1kuIc5wpBHP1CH++BYbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XciBGloNFkqP//Xq+ttF70FZdl5Su7EofdD4Aed5eEs=;
        b=oDq45f2hqgIUQqAv33fCUmFjr8fk65kqfO1HpoIZ+LX5at4TGYgoexRWl6Wp4LZUIc
         JcxGi3l4nD1CgTNPMDsZyVchp5EGFb6kKnvO79Q+NVmfHwvrnKcyW+vaEiU5gcqAnn1d
         Y+uVrdSPoOh6IM1Iry8AyCGWKMgivjNhE1NMmqpFX0tDz6uwFo1MdakdZsBgCJryBIaK
         NxlhFHOA2xIjqywIsfmoyc9iXXo+VxV8C8XAStoH2TP0nSxTXkyAvPHa8OJ5B1Re6N8X
         E+fkCaOE7m23OD2WcPwWg7k6LrA1JVaRTOhCLCj1FpVzPrnoEnqUzYS6Te6TbJzaPaZq
         QaIA==
X-Gm-Message-State: AOAM531XrPbAGhBeEy9VVKar9Ymq8KaDkr34e8fGsVxkj1lDwLjMaPmE
        fcUoDziziqDzJtrSNY5N6zcaIQ==
X-Google-Smtp-Source: ABdhPJxVbnG8sK8NZ6ghN1XKB8xUDI53pY/vM+2+ab37/RB4SUi2K86qvJwXxhsKM+JgtICtWedoVg==
X-Received: by 2002:a17:902:d653:b0:163:78e0:552f with SMTP id y19-20020a170902d65300b0016378e0552fmr27511285plh.63.1654020368361;
        Tue, 31 May 2022 11:06:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id dw15-20020a17090b094f00b001e0b971196csm2311775pjb.57.2022.05.31.11.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:06:08 -0700 (PDT)
Date:   Tue, 31 May 2022 11:06:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: Bug the VM if the emulator accesses a
 non-existent GPR
Message-ID: <202205311104.C517F46AC@keescook>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526210817.3428868-7-seanjc@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 09:08:15PM +0000, Sean Christopherson wrote:
> Bug the VM, i.e. kill it, if the emulator accesses a non-existent GPR,
> i.e. generates an out-of-bounds GPR index.  Continuing on all but
> gaurantees some form of data corruption in the guest, e.g. even if KVM
> were to redirect to a dummy register, KVM would be incorrectly read zeros
> and drop writes.
> 
> Note, bugging the VM doesn't completely prevent data corruption, e.g. the
> current round of emulation will complete before the vCPU bails out to
> userspace.  But, the very act of killing the guest can also cause data
> corruption, e.g. due to lack of file writeback before termination, so
> taking on additional complexity to cleanly bail out of the emulator isn't
> justified, the goal is purely to stem the bleeding and alert userspace
> that something has gone horribly wrong, i.e. to avoid _silent_ data
> corruption.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I like this -- this ends up failing in a relatively clean fashion. (i.e.
it's not actually a BUG(), but rather tells the VM to stop.)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
