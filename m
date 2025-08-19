Return-Path: <kvm+bounces-54938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CC7B2B5CE
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C63A94E89BC
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 01:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776EC1DF273;
	Tue, 19 Aug 2025 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.b="fBdEdbfE"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C0C2110;
	Tue, 19 Aug 2025 01:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755566348; cv=none; b=H3bYQ9gOJjwbdTyWp72PdLIpuF2sNosI7GAiwstqP/YFs4lnf08GRFRV6JqO9ITbSzM1fstwvMD/Iz3B6Xmy7ykNtPaF9pSNiiIapjmgLdIcyPUgeiFexjhmmI5ZD85XLGkZ+mWuq78FtFqKIXEV6qrhf5K8vYns53qreGLISj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755566348; c=relaxed/simple;
	bh=K8h4fsLkwXBoz8bbfEBr50T/b5QSv3uCbvnx5Vw+K6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HoBtRoLWRU9PQ7qCGKmUi9SAlMD1N5eivX5MDvDZqqrtPbyhFvLHVXJ4VSQOmukxwW3TjoUpDNsB0v5fgRcqAxWlucl1Tp7rjBX367CeZ0srNqcaycYDWr5s8lvIVhkDJzxPeTOilK0m7oeanTVRPIQyBA4BamVkALDJqltIec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com; spf=none smtp.mailfrom=linux.spacemit.com; dkim=pass (1024-bit key) header.d=linux.spacemit.com header.i=@linux.spacemit.com header.b=fBdEdbfE; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.spacemit.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.spacemit.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.spacemit.com;
	s=mxsw2412; t=1755566270;
	bh=g6JjCoyupLN35z2qvVI8PUyBR1aUVsz84r9rhHKnBG8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version;
	b=fBdEdbfEtSE3GETmB1e3uL6fxPX8AdUXXyzEFslWrIE5xOZSmIqzUSEEaIdoDCsJu
	 bNRzR5ogWHWYPrrRnMw4IBX0DLWPgv94P/V64TFmA8/sXkKJd9zzGkqRzrRLtHJG+Y
	 3sscIuOVfSW0DKRV2ad2Ayq5HLp7PlhXT9+7deoM=
X-QQ-mid: esmtpgz12t1755566262td4c8f477
X-QQ-Originating-IP: 9iDyEPMT2fIW1OmOGvQwzxzUT/TRlHh13QLu2xmmxSI=
Received: from = ( [61.145.255.150])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 19 Aug 2025 09:17:40 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15089458960345209029
EX-QQ-RecipientCnt: 11
Date: Tue, 19 Aug 2025 09:17:40 +0800
From: Troy Mitchell <troy.mitchell@linux.spacemit.com>
To: zhouquan@iscas.ac.cn, anup@brainfault.org, ajones@ventanamicro.com,
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>
Subject: Re: [PATCH v2 1/6] RISC-V: KVM: Change zicbom/zicboz block size to
 depend on the host isa
Message-ID: <A0B6F37B4275250B+aKPQtDahHgv7Gq6-@LT-Guozexi>
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
 <fef5907425455ecd41b224e0093f1b6bc4067138.1754646071.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fef5907425455ecd41b224e0093f1b6bc4067138.1754646071.git.zhouquan@iscas.ac.cn>
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:linux.spacemit.com:qybglogicsvrsz:qybglogicsvrsz3a-0
X-QQ-XMAILINFO: NI6mNDRHoM9V6UIO0PANqbhBtmIzyi4VxG6uMub6K4uOxD+OaXdF6e+B
	9vdJ7VKtMnuyImz1jxJ6MOydSP6mXnrxf3H4Vm3yR/+FJiwvBM8pbjdW+Wo3pYZg7R+SoCm
	q3Wu93qEbUXAeamdfbJyaDUvvayU/dCz9BFfVYuh+x2YvoiWrDBMU9AWNbhbMIL7HBP4a9u
	ZYA1QJ87l6g82ay2HrJXxO4jtZB6Kw/dzQ8SU2S0gELoocuodX9hQ9KxOFD/mq9wcaX7eNe
	YRaRDHTFJ9E/JG1+XZumDmGPKt0O0vGMIbFk6Fr0DxiD81SX3IvZiwOGx9+ApNQYhQMAEDr
	j9jBMO5N9lS61PH1aWhTj7JECUDy+pszHDPB1t3hSfro8MckFJMh2yXo7vfVxKrm25V6Itq
	dZp1Ckd6vxyhVK7fBL4EzR+iBeJivThc/X7NGkUwmC/rN/OkUkYXDFJkLIuZBMl9MPcGxjX
	bWBxNcduBW+rePJRv8oSYG1nTvTgelS0mFs63Efkq7Y0SZWN0vJc4AKrbPKPK25Q2BPk+B4
	Fm2B6iTsbSL9cfSFLaHTGha8lXt+mVp+3udorSnmo54espk6KXe7azqkJDKOBbiOIublfEi
	kXkwCWMpMAR1JDow2Cx/sELL1K/Wjjaq4dx7qdLGuAEclTisAwYIfuYRCUHScaI//9gHhRA
	6svuHzrvBWJvnDiTMEwEuzwnNQDnvZYz4OhqQWl5x35PVqra9AixV89WH+jxbQasYrmu3Bx
	o9IjTadJbWZXiOx45H/g+Jc2lsdil3WfbhaVVZuKFXROJPflTAjP0NyPuju5AyIaFt18t/U
	4eS9bv7WLM3jEBsKBU5jkTzBnyJq04PDTXLX20fr8AZXmnqBLamCFJaR0X6KfDAvHejCL/E
	Ccu760ETi54XeGDNmaqdP5/G6vf8FmLNwyJKTkZclaAaOfccrkR7rqsqX1CZRHYyWXZFi57
	RASEr2GK28SVsWiC1qSPl1IY5Mseb2KUJtYCnlmOypVPCtz/YasFmGRGaR9aQUWGUMoSyFT
	OM9fTDvFYwjVIes/TLRo+5aVdzsRxYApGzZi2tzFFBhSEtqUHq
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

On Fri, Aug 08, 2025 at 06:18:21PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> The zicbom/zicboz block size registers should depend on the host's isa,
> the reason is that we otherwise create an ioctl order dependency on the VMM.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
Reviwed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>

Best regards,
Troy
> 
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index cce6a38ea54f..6bd64ae17b80 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -277,12 +277,12 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>  		reg_val = vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK;
>  		break;
>  	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
> -		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
> +		if (!riscv_isa_extension_available(NULL, ZICBOM))
>  			return -ENOENT;
>  		reg_val = riscv_cbom_block_size;
>  		break;
>  	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
> -		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
> +		if (!riscv_isa_extension_available(NULL, ZICBOZ))
>  			return -ENOENT;
>  		reg_val = riscv_cboz_block_size;
>  		break;
> @@ -366,13 +366,13 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>  		}
>  		break;
>  	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
> -		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
> +		if (!riscv_isa_extension_available(NULL, ZICBOM))
>  			return -ENOENT;
>  		if (reg_val != riscv_cbom_block_size)
>  			return -EINVAL;
>  		break;
>  	case KVM_REG_RISCV_CONFIG_REG(zicboz_block_size):
> -		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
> +		if (!riscv_isa_extension_available(NULL, ZICBOZ))
>  			return -ENOENT;
>  		if (reg_val != riscv_cboz_block_size)
>  			return -EINVAL;
> @@ -817,10 +817,10 @@ static int copy_config_reg_indices(const struct kvm_vcpu *vcpu,
>  		 * was not available.
>  		 */
>  		if (i == KVM_REG_RISCV_CONFIG_REG(zicbom_block_size) &&
> -			!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
> +			!riscv_isa_extension_available(NULL, ZICBOM))
>  			continue;
>  		else if (i == KVM_REG_RISCV_CONFIG_REG(zicboz_block_size) &&
> -			!riscv_isa_extension_available(vcpu->arch.isa, ZICBOZ))
> +			!riscv_isa_extension_available(NULL, ZICBOZ))
>  			continue;
>  
>  		size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

