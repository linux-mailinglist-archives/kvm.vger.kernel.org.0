Return-Path: <kvm+bounces-71499-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDiyL0KEnGm7IwQAu9opvQ
	(envelope-from <kvm+bounces-71499-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:45:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C9F17A13E
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:45:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA8F532034FF
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C427316184;
	Mon, 23 Feb 2026 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tSV7Rhb+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9074B1C84DE
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864596; cv=none; b=UMIOQqsLBuhrXBwQrlSV0nNKuRQsDAjavpanU5Cg7FKaKY/7ojpxPnGLLBONWdwnQU5n1td1oSmcoT4+4NuxmixHhqwVb1TXbndF+IQyK0TiACkBRdUMEfSee1WYn9G5KEUv7FTIIG/wJDRlNduZRxROD/1q1f46MQsYHDBAMK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864596; c=relaxed/simple;
	bh=mvK24oTTBqZrxHHEFPq3cG7IWQTbAHw8+UO0+UuviSM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qFceGHvit+USeqEd9seMIQfet6U7abmkp+S0z5FLhZr+uVhfMcvpSALOFKUB3Ljpw74wIMekzg056GMR8z57B1GOSfyCJnPbSS0sWgxOm+v/1VTMdsSxn7gYNxXD53nR7/oVlcQpVT9muowTSEzOlzgiKlgceWTRbyUSIl+/bQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tSV7Rhb+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aaf2ce5d81so61259535ad.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 08:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771864594; x=1772469394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yJpQri3B7GVcHe+2iM9Lc81Jg6gKvTThd70NiS5YIcI=;
        b=tSV7Rhb+7trl5vs8l4TFzfSJye7k4hyc0gCT1pm0iQ7KfsqwWQVcAn1resESG+u9js
         4SWk9sZZv+zAZWYD49R4rHPjWPldh+5Vv5Z0EepVHLQzKWhYXiXnmRDNrXyGLl+Qgtz3
         tYxiC/4J/tSTlccy2cHefCI4oAnl36mRyACR32WTnOwc6htQwg3WgTYHXsJO+lNG0Cgl
         272osN5UDbJKzI3zhl9Y9izUNbqA9bgr7QW2aLVPmDNdccPlRvSXuSQeth8jPnQNqfch
         4zbIqpMpBd/29LcnfiBQkNrdj2ngGOX79myuOoBcDbHYafNbMsAAwR8Rr75Gk+1IW/ai
         baEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771864594; x=1772469394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yJpQri3B7GVcHe+2iM9Lc81Jg6gKvTThd70NiS5YIcI=;
        b=kOmGw0YAEnwBk6KC5efmDZnvZ9i2YCgyI5Oda7ZPGs8CAVjSrrATKPcBraMktsiXLS
         KPvSN8i7ve/TlMQujvVDqZJtl0JfS7GcMFz5ZEOyminnvOHYNPkXMOgkXO78GguF6ixM
         /Xw1VQn1lqkL6eekfiS3c922SmrchRJ0WAHxpyjZ6pO9GOCw+Q+4mmqHytJS7motTC5h
         dEe7q1TIhNZbauKx6ensJeCb+POXv6u5nGHEWFPirRMWkuaPppxRMSoRupCa0xOoxeJB
         +ZUwDIQPDM0y2oxfUQcY/eLrLGAkx5O+PM94V7uA3ZLupqSiEduntCvhmjqVByDYbMh7
         //3w==
X-Forwarded-Encrypted: i=1; AJvYcCUV5bTXpkZ6TqXbokdyhqAAUzYvoxq6XpxSeUHLZ+rgtshFS8jLFKjTYwYT899+Shbg6oc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHCaiFwkjbB3iVvEozRog8nWMY9yWE+JRwF6ZgvGr9lhntB+8C
	Q+iIYF/AV6idZWCHnVeId2UpVjgA6iEhKzHCYkNNJJ6cEdIKaAott88ez1nzIkdXXXXd8OkuqxR
	OIdY1sQ==
X-Received: from plrs10.prod.google.com ([2002:a17:902:b18a:b0:2a8:ea98:5b88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef0f:b0:2aa:d506:d189
 with SMTP id d9443c01a7336-2ad74515d1dmr84078595ad.34.1771864593795; Mon, 23
 Feb 2026 08:36:33 -0800 (PST)
Date: Mon, 23 Feb 2026 08:36:32 -0800
In-Reply-To: <20260223162900.772669-3-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223162900.772669-1-tycho@kernel.org> <20260223162900.772669-3-tycho@kernel.org>
Message-ID: <aZyCEBo07EHw2Prk@google.com>
Subject: Re: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in
 SEV-SNP mode
From: Sean Christopherson <seanjc@google.com>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71499-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 46C9F17A13E
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Tycho Andersen wrote:
> diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> index 86ad1c7d068f..c7fda9fc324b 100644
> --- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> +++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
> @@ -213,13 +213,48 @@ static void test_sev_smoke(void *guest, uint32_t type, uint64_t policy)
>  	}
>  }
>  
> +static bool sev_es_allowed(void)
> +{
> +	struct kvm_sev_launch_start launch_start = {
> +		.policy = SEV_POLICY_ES,
> +	};
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int firmware_error, ret;
> +	bool supported = true;
> +
> +	if (!kvm_cpu_has(X86_FEATURE_SEV_ES))
> +		return false;
> +
> +	if (!kvm_cpu_has(X86_FEATURE_SEV_SNP))
> +		return true;
> +
> +	/*
> +	 * In some cases when SEV-SNP is enabled, firmware disallows starting
> +	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
> +	 * check the underlying firmware error for this case.
> +	 */
> +	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
> +					 &vcpu);

If there's a legimate reason why an SEV-ES VM can't be created, then that needs
to be explicitly enumerated in some way by the kernel.  E.g. is this due to lack
of ASIDs due to CipherTextHiding or something?  Throwing a noodle to see if it
sticks is not an option.

> +
> +	ret = __vm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &launch_start,
> +			     &firmware_error);
> +	if (ret == -1 && firmware_error == SEV_RET_UNSUPPORTED) {
> +		pr_info("SEV-ES not supported with SNP\n");
> +		supported = false;
> +	}
> +
> +	kvm_vm_free(vm);
> +	return supported;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
>  
>  	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
>  
> -	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
> +	if (sev_es_allowed())
>  		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
>  
>  	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
> -- 
> 2.53.0
> 

