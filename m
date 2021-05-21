Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFCC38D11C
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 00:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhEUWSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 18:18:03 -0400
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:24192
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229655AbhEUWRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 18:17:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tad98yJMzz/HXirxVD4vJ/eBoq8pP1MexyQz4r3pfsu+rUsk8KGA7eT76IuwzCh6JJ4XVbYXx/ItGk41o2uHIqn7t1fOSPm88SsgcGFrxnrlYEYYrZ88rmi4CiXvJgspW/ssO1/dXup1gX7Er+NGVYopUMzLeUciJXnDuvGzUlkjp+vD3w8bz0ZnSkAAHf6OlvLtSY7JB7av/OzTEi4Jel7eG6WhQTrduD+KAlhWOiGzJowNp0yFxm4dB4kXjZD3cXnGIURfccTbq/d12uECdYzm6Qs1hhSTdVjYzDrCQ3wau4dzm9r2qxwmfDqg+yNybA3wJ6t87qXEHlT1TMoNRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un3Bp9iXgVG4S/cBMGsgHi6nxEXjkaT3n/ISvWDzjuU=;
 b=QeDpNoY8Qmu2woGLqWMf9OPl+MVPYz24CDpSEBrpO0KeLCQO2BgCyC+2ui+zk6LoneZiR5ZQ/gyS1FO42dqb67l6Q9jboVDN9V5U0OT4M7g6e+ZiAE4hBEUHABquOjJeYadKrzaJ/lFUE5+dst8mT023mx+vBbGUJsTDIA8jV3bm0In+y3YbIcOijPWrlm+AQUqpudC+fM4kxBMx6PYsQCwYujAHaOTkHT9qfCoinN8xyjWBPG6i8+iMxlqN5spq7Ecfba6Drh+xSbF/uBKWAIyydGc4APdFB5bsrfeQ1DqFrGC8XEkb3tKXaRL/RKRBAxpwOVNKZwZeMbiWTGTvAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un3Bp9iXgVG4S/cBMGsgHi6nxEXjkaT3n/ISvWDzjuU=;
 b=H7zWR0EiL9Wjt97WkRFcqkj4L2G+Ocw8PvzUp/6JCptpZCP+rvRd1Odqyk2njRXHsDUnd1egLs+X2zCjQmvFbMRP8LE8Nf3RGWd9uBwasDESIrWLtccLElOlUJxcH/GVTzKAmlh+WQGHXpVxzQIegxpeGsDgSr7pKvG70G1yCB4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2686.namprd12.prod.outlook.com (2603:10b6:805:72::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 21 May
 2021 22:15:56 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 22:15:56 +0000
Cc:     brijesh.singh@amd.com, armbru@redhat.com, dgilbert@redhat.com,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3] target/i386/sev: add support to query the attestation
 report
To:     qemu-devel@nongnu.org
References: <20210429170728.24322-1-brijesh.singh@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9da40603-14d0-73f1-7c81-1f059730101c@amd.com>
Date:   Fri, 21 May 2021 17:15:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210429170728.24322-1-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0074.namprd11.prod.outlook.com
 (2603:10b6:806:d2::19) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 22:15:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dee0b9d0-0e72-4a1f-532d-08d91ca60111
X-MS-TrafficTypeDiagnostic: SN6PR12MB2686:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26862FED0B9754B7A86EA6E1E5299@SN6PR12MB2686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UoQTnQyC6v2s+4zrMcW/kZVz/yOj5ycoQ84AlJNT2LAhkF2F7ZZ8M8WTY1aJKGwbHmyYMy5TvG3G4k50ehl4dvKi1YKCrtplcF2viYn/IdQxQQzZ2t1kQPQXYQ5aV5zXhTaDJ/GXknqoqy1r8ekdce144ltTWvAzWjyjN1+m2mQ568OTHA+AfN0A1SDuAoT1ZCFeCQRm+cBHMC0MRTXnEA/GhplMzKj/akYZJRWkB9jrOfOciJqBYWw6yE6FEkhNN3ZCz3ER4F7wfwnsY+3GwIjfSWKWlvLgz+EJMZq9L/Mflm2ZeKCKu5U8Yb+k4j6KASLtBkcK8FdZyfGvsbe0xeglcD0OfLqu552vFiUWkSVfch9+3N2LxUROzub6KPqznGnd/d1N0bxom8jRH3QUPYvIN5hh91lCluHWmRivvlmfLYKo8YQZxZOEU/JWAhefa7LSBS41yyFuLnbDutkTqZl8DorsLxKUUDwVNdAsFYK8gN2Q6rRMz6qUTovulxyh78PQB+99pCzh7nX9NiCzXVdoJ0MJ4iloELLukVZxeUL3IsL2e2LWOE27MA4wRHuXdJGv1LsuVLHMZTn/TW7Ox/PWSr+uNzt8B3cOXYS+aPNmiviJTjdBGo9PhamM2VOp4Uh6H7LNJOyDA5/ygSlnwyheweUYDP5HW/RRAXpqGawZjd70X2RC8BIjNXCNsck6yxZgRTEZJD2VCS+oesrQz3JbfjVXDuz124MUqXs9lHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(2616005)(956004)(44832011)(6512007)(6506007)(6916009)(66946007)(66556008)(66476007)(83380400001)(31686004)(316002)(6486002)(36756003)(186003)(8936002)(16526019)(52116002)(53546011)(5660300002)(8676002)(38350700002)(54906003)(86362001)(31696002)(26005)(478600001)(4326008)(2906002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ym82bUhETU1aR29Kbjg4UU53bVI4R0ZxUW5QNFArU1prSTlybCtxd1RFdGk3?=
 =?utf-8?B?Q2Fqb1lLOXZ3bWROSWoyTnNIUXpBZUE4bTcwZ0tIRUxhMGdZRWswaTNiTUhq?=
 =?utf-8?B?c0tSTzRUQis1c25VSnRyUWdleVpmc3B6Qys5NFJCcEpIb25PVG1uS0FRKzZx?=
 =?utf-8?B?ZnU0b0c5bmVHV2xXRk5wWTZKbmhCMmJ2NkFvKzVoTGpVN0JPdmQ1Qy9hYmpT?=
 =?utf-8?B?RXh0YzZqWWdBSll2UzROa1lib0wrRGFjczZzM3Q0SG5jSlFCTkVsOWNLN0Q2?=
 =?utf-8?B?OHVLaGxzamw2bkR0MkZGaUkvYkRMQ0lVcEJaZ202dTEvd3RhZkpEenJKREkx?=
 =?utf-8?B?bWlzQWMvOUFVdmNvL3VhM2hrN0wrR1lqMlQ3NUlSeUo0MFk1ZS95blZsdjF5?=
 =?utf-8?B?cC9kdzdTMnFnMVFOdzJlZi9za0N1T0NTcnJlQVNSazYzck0zanhRNzd3d2lL?=
 =?utf-8?B?ZG1OdkFBb3VHN25mdi9ndFlqUFhrVWQxL0FlYWc2djNma01YazRVeUo4dEhu?=
 =?utf-8?B?elRGQW1RSzdXUjd2T0E1aVppREtJUmFrWVlBeFlhMFZ1WmpsTDhhQXcxcGt3?=
 =?utf-8?B?dnY1d0F2bm1JWXNOL1dLSE01cVdUeDFWUlc1QUdZM1UwWGRsSVRacllnaFM5?=
 =?utf-8?B?TmdvZHlvVDJISFFHMGZZV0N0Tyt1U2svVmRNakR0M1ZaVVBPbXRwQndpV1Jm?=
 =?utf-8?B?N1o4TmhsaWxhZEZhSGRBYjY2V2JncEcvWXFWZE5WV1BuVE11QzJrOFd1RVlO?=
 =?utf-8?B?QkMvRm1wSzUzeDNzZWk0NklPckdhZElGUTB2eElxR1Z5bG9YR203d2NxUUpK?=
 =?utf-8?B?WCt0Wjh4ZUdNeGNGRkFtUFkwZWJ5Q3ZLeHByTkRKcG1QQzRPY3BWQnFTOVgv?=
 =?utf-8?B?TDQvME8ySk9NQTNiWW9xb2VZVFpDR2gxS25wV3JsTlJ5bWJQOUw2YVcyTWVH?=
 =?utf-8?B?NzhKbGZrRldtUW85ZUorclFmdWwzdk5LeUhmQUV3cmpFT3NEZW0yRnpiME03?=
 =?utf-8?B?YXV4ajNNZEZDYWh1SWJsWUtnTitRYXRvNFlYMGxrZlVnK1pheE5yZlhmbUxM?=
 =?utf-8?B?bnViVTcybWdOeEFDSW03MUxOWW0wcHdxN0k4WmZlV2JNZi9BT25ZYXJPS0Np?=
 =?utf-8?B?N3BLMjI2MjBqbU5uVWQxKzFpOUloMVNIY3ZVa0R0SGZ3TVIrVHVNczA5R2FP?=
 =?utf-8?B?WksyeFcyd292MktWREsrbHhsUUdOTHdXcHNDcW1IazdoT1IwZWhFR0lFV0kr?=
 =?utf-8?B?WEFtSENiSTBiUGNKSFpoY0tObUNVbzB3Vm8xN0labmF6NzRseVNTOXNnMXds?=
 =?utf-8?B?US9GMjBOM3VjcXo3L0l0YjVuN2toS3pnN3BVajlJTzZpUjlwdE13TWN1Y2FG?=
 =?utf-8?B?eld3SEtydGY5a1pRSFp3NjFhQlZXWTBUeFFyakhKQjJzZGJrYlM3em8yL3hx?=
 =?utf-8?B?NTFrNE0yK283cHpYMmMzT3U1SkM0dFE2N28xZ214cjVWdC9SY1hEZG1IQzRF?=
 =?utf-8?B?Q1kxMXo3RmJGYkpzT1h6eld5bjF6bUlUckl2RWxkRDRSdjNKZEtXTWtIek96?=
 =?utf-8?B?SUQzaDFOeTZwY2VpRWMvdElwYm00bmgwN09LM0dtWE1PMHJQYVNVK0tLMEdn?=
 =?utf-8?B?KzdOS1RRWXlsamplVDljZUc5bjFTOUJoa1kwS2U0dkJpa0RrUFZxaWdwRXd2?=
 =?utf-8?B?TVpmOWIweUJ0VVJjSERUNkFNUVFtaGV3MkdHMGdjUTYvVGV4V3FXQTFEK2NG?=
 =?utf-8?Q?hOpDCBZtl7AObHqQQ3I0rScZavVt/XVrYwdKNwc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee0b9d0-0e72-4a1f-532d-08d91ca60111
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 22:15:56.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRVAKwu+OZu6YLvmUFeEYka3huaKI184PRAONR8SEDxNM5PGxNVouQdryRmZnKRC192uOUZPwktQoZrTOizXwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2686
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Ping. Please let me know if you have any feedback on this patch.

Thanks

On 4/29/21 12:07 PM, Brijesh Singh wrote:
> The SEV FW >= 0.23 added a new command that can be used to query the
> attestation report containing the SHA-256 digest of the guest memory
> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
>
> Note, we already have a command (LAUNCH_MEASURE) that can be used to
> query the SHA-256 digest of the guest memory encrypted through the
> LAUNCH_UPDATE. The main difference between previous and this command
> is that the report is signed with the PEK and unlike the LAUNCH_MEASURE
> command the ATTESATION_REPORT command can be called while the guest
> is running.
>
> Add a QMP interface "query-sev-attestation-report" that can be used
> to get the report encoded in base64.
>
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
> Cc: Eric Blake <eblake@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Reviewed-by: James Bottomley <jejb@linux.ibm.com>
> Tested-by: James Bottomley <jejb@linux.ibm.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> v3:
>   * free the buffer in error path.
>
> v2:
>   * add trace event.
>   * fix the goto to return NULL on failure.
>   * make the mnonce as a base64 encoded string
>
>  linux-headers/linux/kvm.h |  8 +++++
>  qapi/misc-target.json     | 38 ++++++++++++++++++++++
>  target/i386/monitor.c     |  6 ++++
>  target/i386/sev-stub.c    |  7 ++++
>  target/i386/sev.c         | 67 +++++++++++++++++++++++++++++++++++++++
>  target/i386/sev_i386.h    |  2 ++
>  target/i386/trace-events  |  1 +
>  7 files changed, 129 insertions(+)
>
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 020b62a619..897f831374 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1591,6 +1591,8 @@ enum sev_cmd_id {
>  	KVM_SEV_DBG_ENCRYPT,
>  	/* Guest certificates commands */
>  	KVM_SEV_CERT_EXPORT,
> +	/* Attestation report */
> +	KVM_SEV_GET_ATTESTATION_REPORT,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -1643,6 +1645,12 @@ struct kvm_sev_dbg {
>  	__u32 len;
>  };
>  
> +struct kvm_sev_attestation_report {
> +	__u8 mnonce[16];
> +	__u64 uaddr;
> +	__u32 len;
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 0c7491cd82..4b62f0ac05 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -285,3 +285,41 @@
>  ##
>  { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'],
>    'if': 'defined(TARGET_ARM)' }
> +
> +
> +##
> +# @SevAttestationReport:
> +#
> +# The struct describes attestation report for a Secure Encrypted Virtualization
> +# feature.
> +#
> +# @data:  guest attestation report (base64 encoded)
> +#
> +#
> +# Since: 6.1
> +##
> +{ 'struct': 'SevAttestationReport',
> +  'data': { 'data': 'str'},
> +  'if': 'defined(TARGET_I386)' }
> +
> +##
> +# @query-sev-attestation-report:
> +#
> +# This command is used to get the SEV attestation report, and is supported on AMD
> +# X86 platforms only.
> +#
> +# @mnonce: a random 16 bytes value encoded in base64 (it will be included in report)
> +#
> +# Returns: SevAttestationReport objects.
> +#
> +# Since: 6.1
> +#
> +# Example:
> +#
> +# -> { "execute" : "query-sev-attestation-report", "arguments": { "mnonce": "aaaaaaa" } }
> +# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
> +#
> +##
> +{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
> +  'returns': 'SevAttestationReport',
> +  'if': 'defined(TARGET_I386)' }
> diff --git a/target/i386/monitor.c b/target/i386/monitor.c
> index 5994408bee..119211f0b0 100644
> --- a/target/i386/monitor.c
> +++ b/target/i386/monitor.c
> @@ -757,3 +757,9 @@ void qmp_sev_inject_launch_secret(const char *packet_hdr,
>  
>      sev_inject_launch_secret(packet_hdr, secret, gpa, errp);
>  }
> +
> +SevAttestationReport *
> +qmp_query_sev_attestation_report(const char *mnonce, Error **errp)
> +{
> +    return sev_get_attestation_report(mnonce, errp);
> +}
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> index 0207f1c5aa..0227cb5177 100644
> --- a/target/i386/sev-stub.c
> +++ b/target/i386/sev-stub.c
> @@ -74,3 +74,10 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
>  {
>      abort();
>  }
> +
> +SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp)
> +{
> +    error_setg(errp, "SEV is not available in this QEMU");
> +    return NULL;
> +}
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 72b9e2ab40..4b9d7d3bb9 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -491,6 +491,73 @@ out:
>      return cap;
>  }
>  
> +SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp)
> +{
> +    struct kvm_sev_attestation_report input = {};
> +    SevAttestationReport *report = NULL;
> +    SevGuestState *sev = sev_guest;
> +    guchar *data;
> +    guchar *buf;
> +    gsize len;
> +    int err = 0, ret;
> +
> +    if (!sev_enabled()) {
> +        error_setg(errp, "SEV is not enabled");
> +        return NULL;
> +    }
> +
> +    /* lets decode the mnonce string */
> +    buf = g_base64_decode(mnonce, &len);
> +    if (!buf) {
> +        error_setg(errp, "SEV: failed to decode mnonce input");
> +        return NULL;
> +    }
> +
> +    /* verify the input mnonce length */
> +    if (len != sizeof(input.mnonce)) {
> +        error_setg(errp, "SEV: mnonce must be %ld bytes (got %ld)",
> +                sizeof(input.mnonce), len);
> +        g_free(buf);
> +        return NULL;
> +    }
> +
> +    /* Query the report length */
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +            &input, &err);
> +    if (ret < 0) {
> +        if (err != SEV_RET_INVALID_LEN) {
> +            error_setg(errp, "failed to query the attestation report length "
> +                    "ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
> +            g_free(buf);
> +            return NULL;
> +        }
> +    }
> +
> +    data = g_malloc(input.len);
> +    input.uaddr = (unsigned long)data;
> +    memcpy(input.mnonce, buf, sizeof(input.mnonce));
> +
> +    /* Query the report */
> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> +            &input, &err);
> +    if (ret) {
> +        error_setg_errno(errp, errno, "Failed to get attestation report"
> +                " ret=%d fw_err=%d (%s)", ret, err, fw_error_to_str(err));
> +        goto e_free_data;
> +    }
> +
> +    report = g_new0(SevAttestationReport, 1);
> +    report->data = g_base64_encode(data, input.len);
> +
> +    trace_kvm_sev_attestation_report(mnonce, report->data);
> +
> +e_free_data:
> +    g_free(data);
> +    g_free(buf);
> +    return report;
> +}
> +
>  static int
>  sev_read_file_base64(const char *filename, guchar **data, gsize *len)
>  {
> diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
> index ae221d4c72..ae6d840478 100644
> --- a/target/i386/sev_i386.h
> +++ b/target/i386/sev_i386.h
> @@ -35,5 +35,7 @@ extern uint32_t sev_get_cbit_position(void);
>  extern uint32_t sev_get_reduced_phys_bits(void);
>  extern char *sev_get_launch_measurement(void);
>  extern SevCapability *sev_get_capabilities(Error **errp);
> +extern SevAttestationReport *
> +sev_get_attestation_report(const char *mnonce, Error **errp);
>  
>  #endif
> diff --git a/target/i386/trace-events b/target/i386/trace-events
> index a22ab24e21..8d6437404d 100644
> --- a/target/i386/trace-events
> +++ b/target/i386/trace-events
> @@ -10,3 +10,4 @@ kvm_sev_launch_update_data(void *addr, uint64_t len) "addr %p len 0x%" PRIx64
>  kvm_sev_launch_measurement(const char *value) "data %s"
>  kvm_sev_launch_finish(void) ""
>  kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
> +kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
