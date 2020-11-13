Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178D22B19AE
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 12:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKMLLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 06:11:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgKMLJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 06:09:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADB4tWw102474;
        Fri, 13 Nov 2020 11:07:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ExnlqPB2s2k0Bn6NwVn/D1kZ0VcR8wU+sL7wRM7sAbU=;
 b=JpxBzXS4oSxAgKcDaPe+x7mCf1uKaG52fA/XVR7jT4niX4knB6vCS870jxZxljCSt0mN
 0tGoIDZkZh4tTrfgq+zLhxx0qMC94N7dEqXo3025pG3mP8351VtEOyXBQxuyDh/b6XFD
 k6hvqTj+t1UqcE4YP1ZFLT/JBx3TnFTdabuJ/PvOiFAWLvjzfP1d923PjuQOklJd7eaI
 uEC/Pi7swzyzo4UV4yryidCJnRRWmC5/p1pdSnMrer0z9ydd9R8QXj06KdnFmwK63CGO
 I/RMv+t87SJKpr8NCFXefPpK0Y4+ANyEBxivHBLDesFYR5uDhUrxoYRBX+Sx3TyxFkzh Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhm9wq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 11:07:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADB6J4t132163;
        Fri, 13 Nov 2020 11:07:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34rtktdyxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 11:07:43 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ADB7aET021686;
        Fri, 13 Nov 2020 11:07:36 GMT
Received: from [10.175.169.218] (/10.175.169.218)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 03:07:36 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH] KVM: x86: clflushopt should be treated as a no-op by
 emulation
To:     David Edmondson <david.edmondson@oracle.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20201103120400.240882-1-david.edmondson@oracle.com>
Message-ID: <2f1e370f-2dbf-2935-ba26-b6dacf6eec0d@oracle.com>
Date:   Fri, 13 Nov 2020 11:07:31 +0000
MIME-Version: 1.0
In-Reply-To: <20201103120400.240882-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130068
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/20 12:04 PM, David Edmondson wrote:
> The instruction emulator ignores clflush instructions, yet fails to
> support clflushopt. Treat both similarly.
> 
> Fixes: 13e457e0eebf ("KVM: x86: Emulator does not decode clflush well")
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>

FWIW,

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  arch/x86/kvm/emulate.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 0d917eb70319..56cae1ff9e3f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4046,6 +4046,12 @@ static int em_clflush(struct x86_emulate_ctxt *ctxt)
>  	return X86EMUL_CONTINUE;
>  }
>  
> +static int em_clflushopt(struct x86_emulate_ctxt *ctxt)
> +{
> +	/* emulating clflushopt regardless of cpuid */
> +	return X86EMUL_CONTINUE;
> +}
> +
>  static int em_movsxd(struct x86_emulate_ctxt *ctxt)
>  {
>  	ctxt->dst.val = (s32) ctxt->src.val;
> @@ -4585,7 +4591,7 @@ static const struct opcode group11[] = {
>  };
>  
>  static const struct gprefix pfx_0f_ae_7 = {
> -	I(SrcMem | ByteOp, em_clflush), N, N, N,
> +	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
>  };
>  
>  static const struct group_dual group15 = { {
> 
