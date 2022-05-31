Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650255395DD
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 20:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbiEaSGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 14:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346816AbiEaSGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 14:06:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8369BAF7
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:06:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so3024605pjt.4
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 11:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U8KygP5HX4ANbWdbvL1PVBHCmW/9zwhKWrTofJUHJ8g=;
        b=KpPTUTlHGzyq7z5TXtGgnCLsz3TsaVTwnC4R9n6g0KBCtTdRfC2tR5xORvaoaLa8zh
         09JbbaBhFlQfDHE5Fj8AzFo66zQtsoCo92UplQ4sBBRovj11j68IW/cDcnFkkALLfQkI
         pvNwSTgedSrgMdoDINic6e3UhJLDzHxkj4xno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U8KygP5HX4ANbWdbvL1PVBHCmW/9zwhKWrTofJUHJ8g=;
        b=CuGrI/Tz+67Ga80eLN/dWMOdA3oYqkTLLhXzcldqThcbSVKPddYw9W4+57B9A0PSER
         aLVnYiIUuVJluLWidHT1WGsvnG3OwUeqErPLw2QdnVllu8N9yFsx4cZR9FiXUXJvVnWs
         cISfpL7jiihhwYq18D/NcnWI3vec+BWf3xQ+CmnbG2ZDlpN+acqDWiTFAAZ9PpL9Le57
         uTNz39yeKc16RR5QRTtGwcj3jVBstmT/N9InqCcCve8kIcB8+MtlCAqu0JoYWZ1hzn31
         gBT/L8DRbzp0lUT1Ak7B+2qORUsWojd6U2drdTcrbOQliyPLPzNobSiwBW3uu0uAmWgC
         Yhqg==
X-Gm-Message-State: AOAM530Y0W0hj2TCigW0votwbEyL/qUNVuC/DgBySkb5mfrGerhd/0pw
        Udr5n1+LYtdZ6mGs9eba4Y6lyA==
X-Google-Smtp-Source: ABdhPJxk0k0IE5MQ41zL5Wf8a/XJyLVLt7RJkuxqWxrzaxR2uwDa6Fx1or0jb5xUH07KYscnYdZ2Rw==
X-Received: by 2002:a17:90a:2e83:b0:1da:3273:53ab with SMTP id r3-20020a17090a2e8300b001da327353abmr30031100pjd.14.1654020376713;
        Tue, 31 May 2022 11:06:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902f54600b0016170bb6528sm11559540plf.113.2022.05.31.11.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:06:16 -0700 (PDT)
Date:   Tue, 31 May 2022 11:06:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: Bug the VM on an out-of-bounds data read
Message-ID: <202205311106.76479DB1E6@keescook>
References: <20220526210817.3428868-1-seanjc@google.com>
 <20220526210817.3428868-9-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526210817.3428868-9-seanjc@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 09:08:17PM +0000, Sean Christopherson wrote:
> Bug the VM and terminate emulation if an out-of-bounds read into the
> emulator's data cache occurs.  Knowingly contuining on all but guarantees
> that KVM will overwrite random kernel data, which is far, far worse than
> killing the VM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
