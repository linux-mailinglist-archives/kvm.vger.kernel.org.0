Return-Path: <kvm+bounces-22669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9549411C0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 14:22:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A38B1F244E4
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6BF19F460;
	Tue, 30 Jul 2024 12:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbWoP+wF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0E91991DB
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 12:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722342151; cv=none; b=IKCU+RLm63gCkMWnzVVGbZljNNDKzByTxz0MFuOQv9Sf/9EchWhtDyjSZpN42qJL9S5Qkqk3Fvb93JY4xAxcs6X4VdZzQ+IDQ1QBaaLQl5MR27O8zPfTG+ndV6aSY4RiqQ2kdNq2vTKe6odVshpA0S/ae+klv4MlB+Civ40GGs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722342151; c=relaxed/simple;
	bh=/ra8/zxjSbL5tHf9lFwv54oZ22wSEImovpSQKo9FeZ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=sjRVi9C/ryFWIrm0A0HDBEsnd5wlMo6gLwtB/4BUAbsa6u+Pz0G0p5IE13ahfjnDDkvu2+17klsJXDUwFckaDA2Q3NQFjqTaoPSC0+YeXMMG5/G74K5lI5xvRS0K7hQJNymL+m1FuF0kBg2OPZewXRHyHdGLyszzSs0wZEoogxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fbWoP+wF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722342147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JRk+4VeVtW9bJfH/zMAgm0k34GZlfKGTGWDXXfmPzw0=;
	b=fbWoP+wFVZ8ZGs74wMvW450zZse4WsMU8lsjVAQ3yuUwgClJQyiutv5sUFIVnusCKQqkE3
	pZVV3BeysNvyAJabJBKX3lxt4A6/6YPzVRy5yj7cK6cpED33t8qDdyYFqQPkSdZUCFXKG+
	vOMowdG6ZsOgBdh6r1BcU4ZfSWxv3eU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-Yq6378-hPWec8Bk0LexGnA-1; Tue,
 30 Jul 2024 08:22:22 -0400
X-MC-Unique: Yq6378-hPWec8Bk0LexGnA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3136F1955D56;
	Tue, 30 Jul 2024 12:22:13 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A88419560AA;
	Tue, 30 Jul 2024 12:22:08 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DAB4021E5E71; Tue, 30 Jul 2024 14:22:05 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org,  alex.williamson@redhat.com,
  andrew@codeconstruct.com.au,  andrew@daynix.com,
  arei.gonglei@huawei.com,  berto@igalia.com,  borntraeger@linux.ibm.com,
  clg@kaod.org,  david@redhat.com,  den@openvz.org,  eblake@redhat.com,
  eduardo@habkost.net,  farman@linux.ibm.com,  farosas@suse.de,
  hreitz@redhat.com,  idryomov@gmail.com,  iii@linux.ibm.com,
  jamin_lin@aspeedtech.com,  jasowang@redhat.com,  joel@jms.id.au,
  jsnow@redhat.com,  kwolf@redhat.com,  leetroy@gmail.com,
  marcandre.lureau@redhat.com,  marcel.apfelbaum@gmail.com,
  michael.roth@amd.com,  mst@redhat.com,  mtosatti@redhat.com,
  nsg@linux.ibm.com,  pasic@linux.ibm.com,  pbonzini@redhat.com,
  peter.maydell@linaro.org,  peterx@redhat.com,  philmd@linaro.org,
  pizhenwei@bytedance.com,  pl@dlhnet.de,  richard.henderson@linaro.org,
  stefanha@redhat.com,  steven_lee@aspeedtech.com,  thuth@redhat.com,
  vsementsov@yandex-team.ru,  wangyanan55@huawei.com,
  yuri.benditovich@daynix.com,  zhao1.liu@intel.com,
  qemu-block@nongnu.org,  qemu-arm@nongnu.org,  qemu-s390x@nongnu.org,
  kvm@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>, =?utf-8?Q?C?=
 =?utf-8?Q?=C3=A9dric?= Le Goater
 <clg@redhat.com>
Subject: Re: [PATCH 01/18] qapi: Smarter camel_to_upper() to reduce need for
 'prefix'
In-Reply-To: <ZqiutRoQuAsrllfj@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Tue, 30 Jul 2024 10:13:25 +0100")
References: <20240730081032.1246748-1-armbru@redhat.com>
	<20240730081032.1246748-2-armbru@redhat.com>
	<ZqiutRoQuAsrllfj@redhat.com>
Date: Tue, 30 Jul 2024 14:22:05 +0200
Message-ID: <87mslzgjde.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Avihai, there's a question for you on VfioMigrationState.

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Tue, Jul 30, 2024 at 10:10:15AM +0200, Markus Armbruster wrote:
>> camel_to_upper() converts its argument from camel case to upper case
>> with '_' between words.  Used for generated enumeration constant
>> prefixes.
>>=20
>> When some of the words are spelled all caps, where exactly to insert
>> '_' is guesswork.  camel_to_upper()'s guesses are bad enough in places
>> to make people override them with a 'prefix' in the schema.
>>=20
>> Rewrite it to guess better:
>>=20
>> 1. Insert '_' after a non-upper case character followed by an upper
>>    case character:
>>=20
>>        OneTwo -> ONE_TWO
>>        One2Three -> ONE2_THREE
>>=20
>> 2. Insert '_' before the last upper case character followed by a
>>    non-upper case character:
>>=20
>>        ACRONYMWord -> ACRONYM_Word
>>=20
>>    Except at the beginning (as in OneTwo above), or when there is
>>    already one:
>>=20
>>        AbCd -> AB_CD
>>=20
>> This changes the default enumeration constant prefix for a number of
>> enums.  Generated enumeration constants change only where the default
>> is not overridden with 'prefix'.
>>=20
>> The following enumerations without a 'prefix' change:
>>=20
>>     enum       	     	 	    old camel_to_upper()
>>     				    new camel_to_upper()
>>     ------------------------------------------------------------------
>>     DisplayGLMode                   DISPLAYGL_MODE
>> 				    DISPLAY_GL_MODE
>>     EbpfProgramID                   EBPF_PROGRAMID
>> 				    EBPF_PROGRAM_ID
>>     HmatLBDataType                  HMATLB_DATA_TYPE
>> 				    HMAT_LB_DATA_TYPE
>>     HmatLBMemoryHierarchy           HMATLB_MEMORY_HIERARCHY
>> 				    HMAT_LB_MEMORY_HIERARCHY
>>     MultiFDCompression              MULTIFD_COMPRESSION
>> 				    MULTI_FD_COMPRESSION
>>     OffAutoPCIBAR                   OFF_AUTOPCIBAR
>> 				    OFF_AUTO_PCIBAR
>>     QCryptoBlockFormat              Q_CRYPTO_BLOCK_FORMAT
>> 				    QCRYPTO_BLOCK_FORMAT
>>     QCryptoBlockLUKSKeyslotState    Q_CRYPTO_BLOCKLUKS_KEYSLOT_STATE
>> 				    QCRYPTO_BLOCK_LUKS_KEYSLOT_STATE
>>     QKeyCode                        Q_KEY_CODE
>>     				    QKEY_CODE
>>     XDbgBlockGraphNodeType          X_DBG_BLOCK_GRAPH_NODE_TYPE
>> 				    XDBG_BLOCK_GRAPH_NODE_TYPE
>>     TestUnionEnumA		    TEST_UNION_ENUMA
>>     				    TEST_UNION_ENUM_A
>>=20
>> Add a 'prefix' so generated code doesn't change now.  Subsequent
>> commits will remove most of them again.  Two will remain:
>> MULTIFD_COMPRESSION, because migration code generally spells "multifd"
>> that way, and Q_KEY_CODE, because that one is baked into
>> subprojects/keycodemapdb/tools/keymap-gen.
>>=20
>> The following enumerations with a 'prefix' change so that the prefix
>> is now superfluous:
>>=20
>>     enum       	     	 	    old camel_to_upper()
>>     				    new camel_to_upper() [equal to prefix]
>>     ------------------------------------------------------------------
>>     BlkdebugIOType                  BLKDEBUGIO_TYPE
>> 				    BLKDEBUG_IO_TYPE
>>     QCryptoTLSCredsEndpoint         Q_CRYPTOTLS_CREDS_ENDPOINT
>> 				    QCRYPTO_TLS_CREDS_ENDPOINT
>>     QCryptoSecretFormat             Q_CRYPTO_SECRET_FORMAT
>> 				    QCRYPTO_SECRET_FORMAT
>>     QCryptoCipherMode               Q_CRYPTO_CIPHER_MODE
>> 				    QCRYPTO_CIPHER_MODE
>>     QCryptodevBackendType           Q_CRYPTODEV_BACKEND_TYPE
>> 				    QCRYPTODEV_BACKEND_TYPE
>>     QType [builtin]                 Q_TYPE
>> 				    QTYPE
>>=20
>> Drop these prefixes.
>>=20
>> The following enumerations with a 'prefix' change without making the
>> 'prefix' superfluous:
>>=20
>>     enum       	     	 	    old camel_to_upper()
>>     				    new camel_to_upper() [equal to prefix]
>> 				    prefix
>>     ------------------------------------------------------------------
>>     CpuS390Entitlement              CPUS390_ENTITLEMENT
>> 				    CPU_S390_ENTITLEMENT
>> 				    S390_CPU_ENTITLEMENT
>>     CpuS390Polarization             CPUS390_POLARIZATION
>> 				    CPU_S390_POLARIZATION
>> 				    S390_CPU_POLARIZATION
>>     CpuS390State                    CPUS390_STATE
>> 				    CPU_S390_STATE
>> 				    S390_CPU_STATE
>>     QAuthZListFormat                Q_AUTHZ_LIST_FORMAT
>> 				    QAUTH_Z_LIST_FORMAT
>> 				    QAUTHZ_LIST_FORMAT
>>     QAuthZListPolicy                Q_AUTHZ_LIST_POLICY
>> 				    QAUTH_Z_LIST_POLICY
>> 				    QAUTHZ_LIST_POLICY
>>     QCryptoAkCipherAlgorithm        Q_CRYPTO_AK_CIPHER_ALGORITHM
>> 				    QCRYPTO_AK_CIPHER_ALGORITHM
>> 				    QCRYPTO_AKCIPHER_ALG
>>     QCryptoAkCipherKeyType          Q_CRYPTO_AK_CIPHER_KEY_TYPE
>> 				    QCRYPTO_AK_CIPHER_KEY_TYPE
>> 				    QCRYPTO_AKCIPHER_KEY_TYPE
>>     QCryptoCipherAlgorithm          Q_CRYPTO_CIPHER_ALGORITHM
>> 				    QCRYPTO_CIPHER_ALGORITHM
>> 				    QCRYPTO_CIPHER_ALG
>>     QCryptoHashAlgorithm            Q_CRYPTO_HASH_ALGORITHM
>> 				    QCRYPTO_HASH_ALGORITHM
>> 				    QCRYPTO_HASH_ALG
>>     QCryptoIVGenAlgorithm           Q_CRYPTOIV_GEN_ALGORITHM
>> 				    QCRYPTO_IV_GEN_ALGORITHM
>> 				    QCRYPTO_IVGEN_ALG
>>     QCryptoRSAPaddingAlgorithm      Q_CRYPTORSA_PADDING_ALGORITHM
>> 				    QCRYPTO_RSA_PADDING_ALGORITHM
>> 				    QCRYPTO_RSA_PADDING_ALG
>>     QCryptodevBackendAlgType        Q_CRYPTODEV_BACKEND_ALG_TYPE
>> 				    QCRYPTODEV_BACKEND_ALG_TYPE
>> 				    QCRYPTODEV_BACKEND_ALG
>>     QCryptodevBackendServiceType    Q_CRYPTODEV_BACKEND_SERVICE_TYPE
>> 				    QCRYPTODEV_BACKEND_SERVICE_TYPE
>> 				    QCRYPTODEV_BACKEND_SERVICE
>>=20
>> Subsequent commits will tweak things to remove most of these prefixes.
>> Only QAUTHZ_LIST_FORMAT and QAUTHZ_LIST_POLICY will remain.
>
> IIUC from above those two result in=20
>
> 			    QAUTH_Z_LIST_FORMAT
> 			    QAUTH_Z_LIST_POLICY
>
> Is it possible to add a 3rd rule
>
>  *  Single uppercase letter folds into the previous word

I guess we could.

> or are there valid cases where we have a single uppercase
> that we want to preserve ?

Not now, but I'd prefer to leave predictions to economists.

> It sure would be nice to eliminate the 'prefix' concept,
> that we've clearly over-used, if we can kill the only 2
> remaining examples.

There are a few more, actually.  After this series and outside tests:

    enum       	     	 	    default prefix camel_to_upper()
				    prefix override
    ------------------------------------------------------------------
    BlkdebugEvent                   BLKDEBUG_EVENT
                                    BLKDBG
    IscsiHeaderDigest               ISCSI_HEADER_DIGEST
                                    QAPI_ISCSI_HEADER_DIGEST
    MultiFDCompression              MULTI_FD_COMPRESSION
                                    MULTIFD_COMPRESSION
    QAuthZListFormat                QAUTH_Z_LIST_FORMAT
				    QAUTHZ_LIST_FORMAT
    QAuthZListPolicy                QAUTH_Z_LIST_POLICY
				    QAUTHZ_LIST_POLICY
    QKeyCode                        QKEY_CODE
                                    Q_KEY_CODE
    VfioMigrationState              VFIO_MIGRATION_STATE
                                    QAPI_VFIO_MIGRATION_STATE

Reasons for 'prefix', and what could be done instead of 'prefix':

* BlkdebugEvent: shorten the prefix.

  Could live with the longer names instead.  Some 90 occurences...

* IscsiHeaderDigest

  QAPI version of enum iscsi_header_digest from libiscsi's
  iscsi/iscsi.h.  We use 'prefix' to avoid name clashes.

  Could rename the type to QapiIscsiHeaderDigest instead.

* MultiFDCompression

  Migration code consistently uses prefixes multifd_, MULTIFD_, and
  MultiFD_.

  Could rename the type to MultifdCompression instead, but that just
  moves the inconsistency to the type name.

* QAuthZListFormat and QAuthZListPolicy

  The authz code consistently uses QAuthZ.

  Could make camel_to_upper() avoid the lone Z instead (and hope that'll
  remain what we want).

* QKeyCode

  Q_KEY_CODE is baked into subprojects/keycodemapdb/tools/keymap-gen.

  Could adjust the subproject instead.

* VfioMigrationState

  Can't see why this one has a prefix.  Avihai, can you enlighten me?

Daniel, thoughts?

>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>> ---
>>  qapi/block-core.json                     |  3 +-
>>  qapi/common.json                         |  1 +
>>  qapi/crypto.json                         |  6 ++--
>>  qapi/cryptodev.json                      |  1 -
>>  qapi/ebpf.json                           |  1 +
>>  qapi/machine.json                        |  1 +
>>  qapi/migration.json                      |  1 +
>>  qapi/ui.json                             |  2 ++
>>  scripts/qapi/common.py                   | 42 ++++++++++++++----------
>>  scripts/qapi/schema.py                   |  2 +-
>>  tests/qapi-schema/alternate-array.out    |  1 -
>>  tests/qapi-schema/comments.out           |  1 -
>>  tests/qapi-schema/doc-good.out           |  1 -
>>  tests/qapi-schema/empty.out              |  1 -
>>  tests/qapi-schema/include-repetition.out |  1 -
>>  tests/qapi-schema/include-simple.out     |  1 -
>>  tests/qapi-schema/indented-expr.out      |  1 -
>>  tests/qapi-schema/qapi-schema-test.json  |  1 +
>>  tests/qapi-schema/qapi-schema-test.out   |  2 +-
>>  19 files changed, 37 insertions(+), 33 deletions(-)
>
> Reviewed-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>

Thanks!


