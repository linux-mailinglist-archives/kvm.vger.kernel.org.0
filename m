Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347628B3F1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfHMJSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:18:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40943 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfHMJSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:18:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so799374wmj.5
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jW0tub2UzbL05NcO2bVMEMoWnqz9PpoPHHdwwy4/hhI=;
        b=meI/ww/E5nAH3xBFVXuTBID2Crwa5CogI2U6z3G5GWvri/5GxsUz4WciBkWD0zVX5a
         WbFqHISv9uR6TKo2sHO7ubHWEFo5ppkBkErZYB1ZN7Qk6tqwEAz75DQ71Iu79YTbrDNE
         GEwIN4b9ppOiqAt5PEZAbRdbfphxGRoxSQmknBMrsEvsZsa02DEjx5DwDoHoqCFppTTZ
         Dcgl/DBAOWtUot9Sil6Cna9V9FxjumvyEtDFD1YbxeZLIJPHfDSyrF0BLdCfvzNxOFmX
         ib3RjempBERYU8JC6kwl1Y3Hv78w2457NuR0MgX5KpukzCD2tQC/BR0UFTb65tj7rC8H
         mWNg==
X-Gm-Message-State: APjAAAW/yfpJPc+hsl0IwY32WM0hGuYBCw7QIFQriT+zK+wZ/qivkX2F
        vjgW1iUw+IDRphO/FGVr717OTA==
X-Google-Smtp-Source: APXvYqy54+DaW4YK3FY/VYnqSfCxjCt45GhtNezxaN2179OBpbvne3bv8avk2VnkQaQfREwmbAyE2A==
X-Received: by 2002:a1c:c747:: with SMTP id x68mr2086476wmf.14.1565687881016;
        Tue, 13 Aug 2019 02:18:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5d12:7fa9:fb2d:7edb? ([2001:b07:6468:f312:5d12:7fa9:fb2d:7edb])
        by smtp.gmail.com with ESMTPSA id a19sm43628167wra.2.2019.08.13.02.17.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:18:00 -0700 (PDT)
Subject: Re: [RFC PATCH v6 79/92] kvm: x86: emulate movsd xmm, m64
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-80-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <32506209-7b16-4660-664b-4f6c73dc9433@redhat.com>
Date:   Tue, 13 Aug 2019 11:17:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-80-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 18:00, Adalbert Lazăr wrote:
> From: Mihai Donțu <mdontu@bitdefender.com>
> 
> This is needed in order to be able to support guest code that uses movsd to
> write into pages that are marked for write tracking.
> 
> Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
> ---
>  arch/x86/kvm/emulate.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 34431cf31f74..9d38f892beea 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1177,6 +1177,27 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>  
> +static u8 simd_prefix_to_bytes(const struct x86_emulate_ctxt *ctxt,
> +			       int simd_prefix)
> +{
> +	u8 bytes;
> +
> +	switch (ctxt->b) {
> +	case 0x11:
> +		/* movsd xmm, m64 */
> +		/* movups xmm, m128 */
> +		if (simd_prefix == 0xf2) {
> +			bytes = 8;
> +			break;
> +		}
> +		/* fallthrough */
> +	default:
> +		bytes = 16;
> +		break;
> +	}
> +	return bytes;
> +}
> +
>  static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
>  				    struct operand *op)
>  {
> @@ -1187,7 +1208,7 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
>  
>  	if (ctxt->d & Sse) {
>  		op->type = OP_XMM;
> -		op->bytes = 16;
> +		op->bytes = ctxt->op_bytes;
>  		op->addr.xmm = reg;
>  		read_sse_reg(ctxt, &op->vec_val, reg);
>  		return;
> @@ -1238,7 +1259,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
>  				ctxt->d & ByteOp);
>  		if (ctxt->d & Sse) {
>  			op->type = OP_XMM;
> -			op->bytes = 16;
> +			op->bytes = ctxt->op_bytes;
>  			op->addr.xmm = ctxt->modrm_rm;
>  			read_sse_reg(ctxt, &op->vec_val, ctxt->modrm_rm);
>  			return rc;
> @@ -4529,7 +4550,7 @@ static const struct gprefix pfx_0f_2b = {
>  };
>  
>  static const struct gprefix pfx_0f_10_0f_11 = {
> -	I(Unaligned, em_mov), I(Unaligned, em_mov), N, N,
> +	I(Unaligned, em_mov), I(Unaligned, em_mov), I(Unaligned, em_mov), N,
>  };
>  
>  static const struct gprefix pfx_0f_28_0f_29 = {
> @@ -5097,7 +5118,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  {
>  	int rc = X86EMUL_CONTINUE;
>  	int mode = ctxt->mode;
> -	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
> +	int def_op_bytes, def_ad_bytes, goffset, simd_prefix = 0;
>  	bool op_prefix = false;
>  	bool has_seg_override = false;
>  	struct opcode opcode;
> @@ -5320,7 +5341,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>  			ctxt->op_bytes = 4;
>  
>  		if (ctxt->d & Sse)
> -			ctxt->op_bytes = 16;
> +			ctxt->op_bytes = simd_prefix_to_bytes(ctxt,
> +							      simd_prefix);
>  		else if (ctxt->d & Mmx)
>  			ctxt->op_bytes = 8;
>  	}
> 

Please submit all these emulator patches as a separate series, complete
with testcases for kvm-unit-tests.

Paolo
