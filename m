Return-Path: <kvm+bounces-22653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADD5940D2D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC7631F2420F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42EC3194A6B;
	Tue, 30 Jul 2024 09:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2+7B9Yf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7506194A56
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 09:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722330837; cv=none; b=QRV84R+jOLsCWknbY5EjYiDkOiVpP46dvJ7rY7bjzh7vVbnqeiu6XlplA2rpHJK5ZTT7AiJPrCKD7tGhup5NgCo0WdeP+0BCehlxPTVxZH2ICK4AzyzpQ1cZURR68jgU5I4sh4CyLXyswr1XGIt5zmBt9jD/QpeRPrQ+n+c2dKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722330837; c=relaxed/simple;
	bh=0fAab6w8aA/2ybHIRHyjn5sqMbiIUBA20w3jkUPQBtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8voV/jap7EKBYqE1oxY4DgXlr4TkLtXwDr7Tm2bF+8klAhjeHE1Px0vNzv7oOdC+2ODJrAfPjMzv9fJlKql0vandwPCgCdj7HIs/XS41b2gy3V3SrG2xItIMnRb13S3zcp0twmFi7d2Wb0i88OAuhtnKSNDUOa0eFp0nMfuE7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2+7B9Yf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722330834;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oSLlIJR2ZPU1Tj2WbafVSnV32Cdn2vklNmUjcUUffwU=;
	b=a2+7B9YfburTALjG3rqrdOHHZPfIHY2QIn8nxtM2G9TAC89cB9ByV1yEafDpMTGzasAku3
	yQMgl1yhPyx/RWXDnIeZdtqI+gCxx05G+DIO79JirrPvyM49BPIp2mlvz7BMw9XRoLIgbT
	cFTLU/3IQnha1XBsmy9c6f0DNPh7g+Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-C85vXwjOPM67FfiNoxbJfw-1; Tue,
 30 Jul 2024 05:13:48 -0400
X-MC-Unique: C85vXwjOPM67FfiNoxbJfw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 571EC1955D4F;
	Tue, 30 Jul 2024 09:13:43 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.108])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E423B1955E89;
	Tue, 30 Jul 2024 09:13:28 +0000 (UTC)
Date: Tue, 30 Jul 2024 10:13:25 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, alex.williamson@redhat.com,
	andrew@codeconstruct.com.au, andrew@daynix.com,
	arei.gonglei@huawei.com, berto@igalia.com,
	borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
	den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
	farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
	idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
	jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com,
	kwolf@redhat.com, leetroy@gmail.com, marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com, michael.roth@amd.com, mst@redhat.com,
	mtosatti@redhat.com, nsg@linux.ibm.com, pasic@linux.ibm.com,
	pbonzini@redhat.com, peter.maydell@linaro.org, peterx@redhat.com,
	philmd@linaro.org, pizhenwei@bytedance.com, pl@dlhnet.de,
	richard.henderson@linaro.org, stefanha@redhat.com,
	steven_lee@aspeedtech.com, thuth@redhat.com,
	vsementsov@yandex-team.ru, wangyanan55@huawei.com,
	yuri.benditovich@daynix.com, zhao1.liu@intel.com,
	qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
Message-ID: <ZqiutRoQuAsrllfj@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-2-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240730081032.1246748-2-armbru@redhat.com>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Jul 30, 2024 at 10:10:15AM +0200, Markus Armbruster wrote:
> camel_to_upper() converts its argument from camel case to upper case
> with '_' between words.  Used for generated enumeration constant
> prefixes.
> 
> When some of the words are spelled all caps, where exactly to insert
> '_' is guesswork.  camel_to_upper()'s guesses are bad enough in places
> to make people override them with a 'prefix' in the schema.
> 
> Rewrite it to guess better:
> 
> 1. Insert '_' after a non-upper case character followed by an upper
>    case character:
> 
>        OneTwo -> ONE_TWO
>        One2Three -> ONE2_THREE
> 
> 2. Insert '_' before the last upper case character followed by a
>    non-upper case character:
> 
>        ACRONYMWord -> ACRONYM_Word
> 
>    Except at the beginning (as in OneTwo above), or when there is
>    already one:
> 
>        AbCd -> AB_CD
> 
> This changes the default enumeration constant prefix for a number of
> enums.  Generated enumeration constants change only where the default
> is not overridden with 'prefix'.
> 
> The following enumerations without a 'prefix' change:
> 
>     enum       	     	 	    old camel_to_upper()
>     				    new camel_to_upper()
>     ------------------------------------------------------------------
>     DisplayGLMode                   DISPLAYGL_MODE
> 				    DISPLAY_GL_MODE
>     EbpfProgramID                   EBPF_PROGRAMID
> 				    EBPF_PROGRAM_ID
>     HmatLBDataType                  HMATLB_DATA_TYPE
> 				    HMAT_LB_DATA_TYPE
>     HmatLBMemoryHierarchy           HMATLB_MEMORY_HIERARCHY
> 				    HMAT_LB_MEMORY_HIERARCHY
>     MultiFDCompression              MULTIFD_COMPRESSION
> 				    MULTI_FD_COMPRESSION
>     OffAutoPCIBAR                   OFF_AUTOPCIBAR
> 				    OFF_AUTO_PCIBAR
>     QCryptoBlockFormat              Q_CRYPTO_BLOCK_FORMAT
> 				    QCRYPTO_BLOCK_FORMAT
>     QCryptoBlockLUKSKeyslotState    Q_CRYPTO_BLOCKLUKS_KEYSLOT_STATE
> 				    QCRYPTO_BLOCK_LUKS_KEYSLOT_STATE
>     QKeyCode                        Q_KEY_CODE
>     				    QKEY_CODE
>     XDbgBlockGraphNodeType          X_DBG_BLOCK_GRAPH_NODE_TYPE
> 				    XDBG_BLOCK_GRAPH_NODE_TYPE
>     TestUnionEnumA		    TEST_UNION_ENUMA
>     				    TEST_UNION_ENUM_A
> 
> Add a 'prefix' so generated code doesn't change now.  Subsequent
> commits will remove most of them again.  Two will remain:
> MULTIFD_COMPRESSION, because migration code generally spells "multifd"
> that way, and Q_KEY_CODE, because that one is baked into
> subprojects/keycodemapdb/tools/keymap-gen.
> 
> The following enumerations with a 'prefix' change so that the prefix
> is now superfluous:
> 
>     enum       	     	 	    old camel_to_upper()
>     				    new camel_to_upper() [equal to prefix]
>     ------------------------------------------------------------------
>     BlkdebugIOType                  BLKDEBUGIO_TYPE
> 				    BLKDEBUG_IO_TYPE
>     QCryptoTLSCredsEndpoint         Q_CRYPTOTLS_CREDS_ENDPOINT
> 				    QCRYPTO_TLS_CREDS_ENDPOINT
>     QCryptoSecretFormat             Q_CRYPTO_SECRET_FORMAT
> 				    QCRYPTO_SECRET_FORMAT
>     QCryptoCipherMode               Q_CRYPTO_CIPHER_MODE
> 				    QCRYPTO_CIPHER_MODE
>     QCryptodevBackendType           Q_CRYPTODEV_BACKEND_TYPE
> 				    QCRYPTODEV_BACKEND_TYPE
>     QType [builtin]                 Q_TYPE
> 				    QTYPE
> 
> Drop these prefixes.
> 
> The following enumerations with a 'prefix' change without making the
> 'prefix' superfluous:
> 
>     enum       	     	 	    old camel_to_upper()
>     				    new camel_to_upper() [equal to prefix]
> 				    prefix
>     ------------------------------------------------------------------
>     CpuS390Entitlement              CPUS390_ENTITLEMENT
> 				    CPU_S390_ENTITLEMENT
> 				    S390_CPU_ENTITLEMENT
>     CpuS390Polarization             CPUS390_POLARIZATION
> 				    CPU_S390_POLARIZATION
> 				    S390_CPU_POLARIZATION
>     CpuS390State                    CPUS390_STATE
> 				    CPU_S390_STATE
> 				    S390_CPU_STATE
>     QAuthZListFormat                Q_AUTHZ_LIST_FORMAT
> 				    QAUTH_Z_LIST_FORMAT
> 				    QAUTHZ_LIST_FORMAT
>     QAuthZListPolicy                Q_AUTHZ_LIST_POLICY
> 				    QAUTH_Z_LIST_POLICY
> 				    QAUTHZ_LIST_POLICY
>     QCryptoAkCipherAlgorithm        Q_CRYPTO_AK_CIPHER_ALGORITHM
> 				    QCRYPTO_AK_CIPHER_ALGORITHM
> 				    QCRYPTO_AKCIPHER_ALG
>     QCryptoAkCipherKeyType          Q_CRYPTO_AK_CIPHER_KEY_TYPE
> 				    QCRYPTO_AK_CIPHER_KEY_TYPE
> 				    QCRYPTO_AKCIPHER_KEY_TYPE
>     QCryptoCipherAlgorithm          Q_CRYPTO_CIPHER_ALGORITHM
> 				    QCRYPTO_CIPHER_ALGORITHM
> 				    QCRYPTO_CIPHER_ALG
>     QCryptoHashAlgorithm            Q_CRYPTO_HASH_ALGORITHM
> 				    QCRYPTO_HASH_ALGORITHM
> 				    QCRYPTO_HASH_ALG
>     QCryptoIVGenAlgorithm           Q_CRYPTOIV_GEN_ALGORITHM
> 				    QCRYPTO_IV_GEN_ALGORITHM
> 				    QCRYPTO_IVGEN_ALG
>     QCryptoRSAPaddingAlgorithm      Q_CRYPTORSA_PADDING_ALGORITHM
> 				    QCRYPTO_RSA_PADDING_ALGORITHM
> 				    QCRYPTO_RSA_PADDING_ALG
>     QCryptodevBackendAlgType        Q_CRYPTODEV_BACKEND_ALG_TYPE
> 				    QCRYPTODEV_BACKEND_ALG_TYPE
> 				    QCRYPTODEV_BACKEND_ALG
>     QCryptodevBackendServiceType    Q_CRYPTODEV_BACKEND_SERVICE_TYPE
> 				    QCRYPTODEV_BACKEND_SERVICE_TYPE
> 				    QCRYPTODEV_BACKEND_SERVICE
> 
> Subsequent commits will tweak things to remove most of these prefixes.
> Only QAUTHZ_LIST_FORMAT and QAUTHZ_LIST_POLICY will remain.

IIUC from above those two result in 

			    QAUTH_Z_LIST_FORMAT
			    QAUTH_Z_LIST_POLICY

Is it possible to add a 3rd rule

 *  Single uppercase letter folds into the previous word

or are there valid cases where we have a single uppercase
that we want to preserve ?

It sure would be nice to eliminate the 'prefix' concept,
that we've clearly over-used, if we can kill the only 2
remaining examples.

> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  qapi/block-core.json                     |  3 +-
>  qapi/common.json                         |  1 +
>  qapi/crypto.json                         |  6 ++--
>  qapi/cryptodev.json                      |  1 -
>  qapi/ebpf.json                           |  1 +
>  qapi/machine.json                        |  1 +
>  qapi/migration.json                      |  1 +
>  qapi/ui.json                             |  2 ++
>  scripts/qapi/common.py                   | 42 ++++++++++++++----------
>  scripts/qapi/schema.py                   |  2 +-
>  tests/qapi-schema/alternate-array.out    |  1 -
>  tests/qapi-schema/comments.out           |  1 -
>  tests/qapi-schema/doc-good.out           |  1 -
>  tests/qapi-schema/empty.out              |  1 -
>  tests/qapi-schema/include-repetition.out |  1 -
>  tests/qapi-schema/include-simple.out     |  1 -
>  tests/qapi-schema/indented-expr.out      |  1 -
>  tests/qapi-schema/qapi-schema-test.json  |  1 +
>  tests/qapi-schema/qapi-schema-test.out   |  2 +-
>  19 files changed, 37 insertions(+), 33 deletions(-)

Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


