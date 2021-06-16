Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913993A95DA
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 11:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhFPJTM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 05:19:12 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:24774 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232048AbhFPJTL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 05:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623835024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVzgv2V06B15pCm5f1xhjw0J3ctfeuSX4Dxxa7wqPBM=;
        b=Eiq+2K+QRcq2/9XyXDcFL4WQKu50HpWCH2mH3PDkA7aOE8fxLUVdGeO5Tdm9PQFHuKfXpD
        oLuUv5C3WardiXPe1dtOxri4GcWcL+AQUhHkWa7DZ7evLFKGkLKC7sZM1IvM0tDd5x7oD8
        Zmok8osXB7y3M0qNykmE/nXuDUUXjvQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-aQHlbZq5NWWbZT0CMG_2Bg-1; Wed, 16 Jun 2021 11:17:03 +0200
X-MC-Unique: aQHlbZq5NWWbZT0CMG_2Bg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5hpJZtz5VT9EXBQHkIfFmk+hC3LzZu/QKaURomGTmUZgWmap2WUh2Xdt2WrrzrPLguscN0C+LbjNQK3i61hW0/UNoJHrpyq8YxBbCUAkqV2qCrvEE8qrNsew4niREjX296ej6jcuOzWYN7EL0HZWpsR0jOsH5p1SpqW2d0sgQw9SIwO/BoBZcOlDpbDHD6m8TlGduP+SHJ4CIkYMADGV75tG0f9Tj7N3SFNC5T9x/a9S267G8SlRjT2gam98Tec8T9YCI+JYQhdxn0UVMA+CHksWaIHKJeRcztBu/Sn+ZgEH8v3jHFvzywSy66inZUTHJmaszb6MyejhoMgzIvdOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfWC9HiwtaJd8FkOhgGrRn89ZqdZkcYcmC/IjAHxxm0=;
 b=VoiMjkI51/oBkTbqfXw83O0Np0uWBheU23faZYMAwMdbGsfkfr/32t5cN/W1nrOvR35BkO0Krf1MeozFMQCuZZoyb0IHir55+wqL4/ZXTMWj9dsgcM7P1USjuRx/tT6xlfQ4XvzMMA6ajTowr8RvSDVJphGDh05960ofk7LPizp8b386kUxHjf5cvQZ/kLi/lIwL6prXlzyJwHcDKx+7Zn+e1lZvIcRjiBB5u1d9D57uxhEwYJXx20tOnt8OCuC/OWQ5srh++T7xgsuY2/C5YMdi7u1nqZcobgH4ier+L22RQuzT9knBABh/4tYa6waNE7eb+JvjnoUaJH1htof6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM9PR04MB8416.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 09:17:01 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::55a8:3faa:c572:5e98]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::55a8:3faa:c572:5e98%7]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 09:17:01 +0000
To:     Joerg Roedel <jroedel@suse.de>
CC:     linux-kernel@vger.kernel.org, Varad Gautam <varad.gautam@suse.com>,
        kvm@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210531125035.21105-1-varad.gautam@suse.com>
 <20210602141447.18629-1-varadgautam@gmail.com> <YMDVNHh9KHsha4a+@suse.de>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [PATCH v3] x86: Add a test for AMD SEV-ES guest #VC handling
Message-ID: <77e09c12-0971-e5dc-7002-c88e30e9455e@suse.com>
Date:   Wed, 16 Jun 2021 11:16:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YMDVNHh9KHsha4a+@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [95.90.166.153]
X-ClientProxiedBy: FR3P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::11) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.147] (95.90.166.153) by FR3P281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Wed, 16 Jun 2021 09:17:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99b0226b-3502-4090-12f6-08d930a77fb9
X-MS-TrafficTypeDiagnostic: AM9PR04MB8416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB84169EB4EACFC3F4A90E4850E00F9@AM9PR04MB8416.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: czCla/7o2AhuZVHD2O2lSRsSkm7QR2g8BQMDJohANR78bF28rU04b8IK0KGrtITzE24zUO4kO4szz2VBW5ALdhQi74/RGHwQ/+P1QgNkEhkr5fLo91KL+ZHHkywdhlWvpFkfW4lPHCgv+ypD73OMd4iO/emJBjGA1b8YWCm3sNnmwGQf+6WPpYppXLnwmMJbU5KN9BNKeZpbIP3zdz7eswPrcUAoftqZ7GhrgfNfE+nBI2u8SRFVQTYq+gZ1/WhHMo0cR7cXfLZJcLwsO9CmInb0iSAXNZwvmy4CyyxH6hJTeMMiUkmXrofB71dl79D4HzLPUmoCtgMArVpHomkYMCSjwVZebxyMdLgLEmqU8XrSHQP1tKKq/gd3+qNU3XVtpmudMDV6np9j8C10+b3GVcQjj+5aqV6wCvxnTetNg2uRb/yU6aABM9vUvCnFjelFLLKalkwNGI4s1a9JlETgvmTv0A82bOR+zkcq0T9SEu7G2jJkWp09mL4JbSHOe2X+gr/gOfDNBdZ/OoyyC3IhRXPQ28GthICMhRfS2p230ygkeXiYdekeOd8Ez8BvllxOF4Vc1Ykj5HTkedqeC9Wj3D5M+3dpmOo4kHfeA+8P2PsdsvElJCVBQHhG+ny6hooSrq1QgUPVEc7taWtYd7s0GyFk9Dp89iXdvOY0zhqKNr00A2z5g5FtgmYUj82mQRBJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(396003)(39860400002)(66946007)(66556008)(66476007)(5660300002)(26005)(186003)(16526019)(54906003)(16576012)(316002)(53546011)(38100700002)(66574015)(31686004)(83380400001)(2906002)(6486002)(31696002)(6916009)(86362001)(8676002)(2616005)(4326008)(44832011)(8936002)(36756003)(956004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?up7234tFdwqygn3YO3HOagDF0lUgSGw2yA1LlKFp9iz/UGBDOkHTw7Eb0LAk?=
 =?us-ascii?Q?oQllpmK3cvW0ZRVJBxI7Jp78kf9IkvIxoBMAv8opGjyS1EZk5c6ShXgOnNpR?=
 =?us-ascii?Q?qREbtQu1UMqL6xcyIor4/DndasmxewrUeWPiCnBKaU8HrBOgN6Wzr0+FSNTY?=
 =?us-ascii?Q?6ZNviw4UBngK7DOWa2VVAvz29Cw/wW2EMBBWIwtKWAaufSHbx9Njk6ON3poQ?=
 =?us-ascii?Q?oxKHMfIc4bgWu2UGfwx6da9cvTgUWGhTrQNSeZ8CCsIiIDkmw4rfZf/Mtqeo?=
 =?us-ascii?Q?QXbrdOl1JXOD+VFhdVY3AWKlR+yu/ckkWY0cRJI7vIJWzHdMDDQn7aUxG6ZJ?=
 =?us-ascii?Q?YB5VHhrJTFNL8xS022ZFBEIgqeiLerF4wPCFucolOafdawm/9QWYsJiQ+SKB?=
 =?us-ascii?Q?8HdnfMYMnJVptBxwKkW97ckeXn2LFecFKiqXLDFim96OpBoGFLK/t59mqj35?=
 =?us-ascii?Q?QQqXIw9zzeSrRT9pkNsZEFQxg/GZjCf+afvyPst998keNaiilJ2vKe/J/fWN?=
 =?us-ascii?Q?Ef6lWuhF1W3tmFztfRBazRFLi08kI8yJF43FfYtZb4qdbnZNmqMLhXCYim1e?=
 =?us-ascii?Q?6+vtPf9u2JIPXVzMjeLFlEFDGqNKGhtGTm6W0/L/0tO8xVqJG3QpJ0wAtUzn?=
 =?us-ascii?Q?po6aHOpQXRU4Jf9pfeoiPJkXP6SR3HAY2FiVF4aDXQOrZ/kLIo5oOi1qtCMQ?=
 =?us-ascii?Q?sug2nPqGE+3LaCkyHOIG0LfK4ByWol7AUoyX9Rmc86fmOOlY4zKt3S3/JNkA?=
 =?us-ascii?Q?6WCzGzRlnzVCoL03s57rXq7NK+0fUAS+8SzyS5r4zhSp6gr+64FjgWNcZmfK?=
 =?us-ascii?Q?DrOuM1ZXE8tgkJLMd3k1CcUWQpojMJfe+DUwQu+asV6W1n7s4MuK4dh40yYh?=
 =?us-ascii?Q?M0VGLiEFhu/UcNHQexgyeL/PO36dksUu5pUOg5YpvIxmvDE29EkaaLQWDnHh?=
 =?us-ascii?Q?/GlqZEGtgFObNQmLFWQP6BL9kA4EJyTIacsZc+RpJ0SRDnDj9+VZ/Y5oM9Ek?=
 =?us-ascii?Q?N04cNE9bvtaUSez422L+/zXMWFLgKPgNM9OlBA4+ZRdCgMe4YEqlk5me/FYG?=
 =?us-ascii?Q?uoRrXL1iawVvrQ84u+RQfYvQLi+xXcEaY9mfD0Lqig+fJZd0a7l6abcnSVD8?=
 =?us-ascii?Q?/HwjOhyLlSiFx9w9KM2tZ0pAH1gLxdW4CZCDN55KivuUBD0ChElXNJfSdOzs?=
 =?us-ascii?Q?m/XJtZclnHcE4C82xLH4CH6vIS6brzac050dMhMlw4QVD0SpTfUv8b18Gmi7?=
 =?us-ascii?Q?2c0yDcjtgd7uqOz8kQqXmSyPjQ6Y57mJQvnhhF0PnjJI8PWOSJaWTkPSMuND?=
 =?us-ascii?Q?A02OLVdi/K/Dxk4+aPukslkB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b0226b-3502-4090-12f6-08d930a77fb9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 09:17:01.1881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skl6hZX5dT+WIyGDrNd8cY/tMgRFBoOcMXgfT8ODHO5IHYW3mLbuwUO+TZPykj+UM9CWCUQNwoZ6z5dfQwshHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8416
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/21 4:50 PM, Joerg Roedel wrote:
> On Wed, Jun 02, 2021 at 04:14:47PM +0200, Varad Gautam wrote:
>> From: Varad Gautam <varad.gautam@suse.com>
>>
>> Some vmexits on a SEV-ES guest need special handling within the guest
>> before exiting to the hypervisor. This must happen within the guest's
>> \#VC exception handler, triggered on every non automatic exit.
>>
>> Add a KUnit based test to validate Linux's VC handling. The test:
>> 1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>>    access GHCB before/after the resulting VMGEXIT).
>> 2. tiggers an NAE.
>> 3. checks that the kretprobe was hit with the right exit_code available
>>    in GHCB.
>>
>> Since relying on kprobes, the test does not cover NMI contexts.
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  arch/x86/Kconfig                 |   9 ++
>>  arch/x86/kernel/Makefile         |   8 ++
>>  arch/x86/kernel/sev-es-test-vc.c | 155 +++++++++++++++++++++++++++++++
>=20
> This looks good to me except for the small comment below, thanks Varad.
> I ran it in an SEV-ES guest and I am seeing the test results in dmesg.
> Only thing I am missing is a 'rep movs' test for MMIO, but that can be
> added later, so
>=20
> Tested-by: Joerg Roedel <jroedel@suse.de>
>=20
> Btw, should we create a separate directory for such tests like
> /arch/x86/tests/ or something along those lines?
>=20

Thanks, I've sent out a v4 with the test moved to arch/x86/tests. This is
now hidden behind a CONFIG_X86_TESTS, where more stuff can be plugged in.

>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 0045e1b441902..85b8ac450ba56 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1543,6 +1543,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>>  	  If set to N, then the encryption of system memory can be
>>  	  activated with the mem_encrypt=3Don command line option.
>> =20
>> +config AMD_SEV_ES_TEST_VC
>> +	bool "Test for AMD SEV-ES VC exception handling."
>> +	depends on AMD_MEM_ENCRYPT
>> +	select FUNCTION_TRACER
>> +	select KPROBES
>> +	select KUNIT
>> +	help
>> +	  Enable KUnit-based testing for AMD SEV-ES #VC exception handling.
>> +
>=20
> I think this should be in arch/x86/Kconfig.debug.
>=20
Ack, also moved in v4.

Varad

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

