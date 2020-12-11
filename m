Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0F22D7678
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 14:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389363AbgLKNYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 08:24:32 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:62854
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727476AbgLKNX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 08:23:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ9/AoiuwZr4clNF9h8Tsyu+5P+I0MWxvEuQIsM1x1mDmAJTwDFoJPQPkPEP/FqINM55LruoDxQ766WJ0vHYgbvzJJSBXfhAHdu1vYhMm6rjb6/G/fyFqgBNhHaMdxqVdnyEMoLWhwN1cr0NUkULthRKJvEStIBme1c3hi9JPfKuptNAPCmPE3mlcC/PVZ/sT5iTFWhnwM6LxQy+V20YRv2UCUcdN4qFOSi7s+Iq4slvMwsxAta1JOH3P2m5j2b5cOS5yw3DsxVn4Z0sqwsWWksrApJbtE4W4U8ge6St/UALiHvfS32NWVdJBuXwwnnsrX3UyLjMfaUnq5h0vfFdaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sumf3+dpkoh2gQwcDHN+bOdeE9sYIldXbmH2iQMlu6c=;
 b=JGbJBITGMvJ+JOS4k5wWOPrRomJ44bxpvCMAQ6fBIiq0YppAvlTwjQPi9JC71IR+xZlekJ60b0tRXyuII3PYHRbpaPiP+GUiPCp9Ir+uE8MOPuO8en2XikES6KbFIvsCa7PiBDKEmSyUgD6oZwlEcIa3KKuu/3M9zrnTdVVeeZM0C4ktaM2LhJR4o3dPi1iTV8kI9eQVCT+934IUQH529nr6Iw6J2eH7YRajx1YCN7h7aMCYkwQ8orM4/fPggpBXzBsZqkIxLPjW7nzXiEMrN6iAD0f1XuK0a+zgJxARUDH8pzQJmFffbOUc7UFjS3uxnNZjXl1p+9kdhBqkYE/OtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sumf3+dpkoh2gQwcDHN+bOdeE9sYIldXbmH2iQMlu6c=;
 b=2jIUOb42TrgWdHlOpELseCojNX6fqCK9Lq5bNK6ztcI4nQWrRi9Z4C8X7Ao+Vu8+QCM1/FiVXRTMip5LPg/kJNTcBLUaRL+OjfcBuNvB5YI07emNXdn9u4ZMl5I0lTzjdvk2BRlLbv16lCEXmhIX/PEpqkYLF7VhTgUhdIMgDnk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Fri, 11 Dec
 2020 13:23:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::18a2:699:70b3:2b8a%6]) with mapi id 15.20.3654.017; Fri, 11 Dec 2020
 13:23:04 +0000
Cc:     brijesh.singh@amd.com, Tom Lendacky <Thomas.Lendacky@amd.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] target/i386/sev: add the support to query the attestation
 report
To:     jejb@linux.ibm.com, qemu-devel@nongnu.org
References: <20201204213101.14552-1-brijesh.singh@amd.com>
 <22795177a81715d31a141887771b21e518b363c7.camel@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <002581c5-d632-cb12-1fcb-7bcbdddd6060@amd.com>
Date:   Fri, 11 Dec 2020 07:23:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <22795177a81715d31a141887771b21e518b363c7.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0701CA0025.namprd07.prod.outlook.com
 (2603:10b6:803:2d::22) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0701CA0025.namprd07.prod.outlook.com (2603:10b6:803:2d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13 via Frontend Transport; Fri, 11 Dec 2020 13:23:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f611e1eb-9a3b-445f-d1ce-08d89dd7e418
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB441336F6D8F73071DB6102CAE5CA0@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sLvzweJBWHlclcVWJvIwZxh4jes6mWkvue8aZJIXgyRHjFzby0gZ5YYcCL0oS1iQ+tZ5eI3zEoulxZGy/lFJcbSnluX8qwKwXnwPLVqtvMeThDfX2vxIJRAWE81nlvbhqnLfpyDHZ5G4S1yXvi1uCX/jnQql+PJV3a4t9A08zbOeCbL2Gja4/yV4VpxdX4oaSDQihWR6g5gNAFLRF+8RUR+32zb7Ls4EsO4aHeabAeRyQjdTNqbn0n1iFvfeRbCXC7qOixPywTEo5nY0a3ZSRav9Kq9mLM4eb1/9/aHDWlnYMAkjZrtxM11k1uG0INwPt3lEf0wh2+GnbwfhGyAmDB029fQxz6hXM72C12xADipdiyztXdmR66pgHPwMpKutaRrG/H+PIPnhoLX6Yo1k1pczDLFFrBnbbmesPRCgpdmJIJ1ZNx7gw+wgW3TzHM/e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(54906003)(16526019)(66476007)(186003)(6512007)(36756003)(6486002)(4326008)(8676002)(956004)(2616005)(83380400001)(34490700003)(44832011)(31696002)(66946007)(5660300002)(52116002)(66556008)(2906002)(53546011)(6506007)(86362001)(508600001)(31686004)(26005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TEJ4dGIwZ1FuYUFrYXN1OTAyRmxHRkU2ekN3U2xMZ3ZCVkRsWkY5dEhlRmds?=
 =?utf-8?B?STBkM1pEcUlIdUp0dFp4aGVVR2F6T2syRnBrV21MQktaOE5ieDZCcXBDVXpo?=
 =?utf-8?B?em5hZ3RtNXhGWlJoRS9sZUpkZjFKTEVoRlBZTGNkZmJpUVM2cjZxdGc5cW1w?=
 =?utf-8?B?SmduNmQwamNSd25NemtoeE5JVGFPUGVvSEtZMU9VZSt3bmRhbkg0a2pPUldR?=
 =?utf-8?B?M3gxeDcwdjFtM3JYYytvUzI1aGhIVVgxQzREVDl3RWJ5ZHlFSTNFS0ZZQjhv?=
 =?utf-8?B?YmNHS0RoM0hCb1hSOUxzUktlVXVlSlg2TEM2OG5mWFdRQWx2eGl3dXQ4NG9a?=
 =?utf-8?B?bVYvVGJCRmo0c3FvSlBoU3Y4N2NkSWNRamRyZWgzcWdRWGJsbWVMSGdoQnFH?=
 =?utf-8?B?eWdmNlBJcS9OZFlKNXpoSklJdGhKVU0xMVBSa1YyTlkrd2hDSUg4S3k2b0sz?=
 =?utf-8?B?UzNYY1k0S3gxSFIyQXZsZTJ3bmk0bzB6RVFiV0xQVkNzYVQ0elZidWJDSkxr?=
 =?utf-8?B?d2VsM3d1QkEzRnhyUDVMMFUrcmU1QjdlT2tkRFN2VGQvQlo5UDZRaGdZa01a?=
 =?utf-8?B?R0ZydXlHbW9DZHhZYlNCbUh1UzY2eVdGZHpWOEJRT2FrL24vS2ZWREkrUUd0?=
 =?utf-8?B?Z0kxc0RkajFLK2FZam5oK0VKbVh1WlkyY3FoOG5OOEM3SjI1RkwvMlFxY2Qx?=
 =?utf-8?B?SjF1NWdsQjNtWnk3aFlmeHhWWmxaSWtIbzBpUDJhTnJReWc1ZjFyMlpqaDc5?=
 =?utf-8?B?UXljM1NDTXV6U1pBSG5CbTJ4bnRkWi9hK2RHNHBFNGZ6SktYd2Z0eW8zWHl5?=
 =?utf-8?B?eDZZSDlpZVB4dnk1aW04N09yd1V6TC84TEoyLzZtN3pNNENMUHJUQVA4alJC?=
 =?utf-8?B?S3VwY3ZQcXZoNVJ2cFdnaXJhUEN1ZXRraUhOS3FaUjNmWnl6Qjdsa1k5by9Y?=
 =?utf-8?B?WldUMm1INWZEK1dNMHlhOHZwUTZvZUdMaXZVREIxWWxmZWxMS3FwQ01tdkdj?=
 =?utf-8?B?THh0Zm11eW1ZYk9xM284NVA1aTdOYkFYUFlmT0tFc2kzZTU1a09qL0ZpTzQ0?=
 =?utf-8?B?YzAwSUczZ1JsK1dLNE9Wb2ZpdkRRalJGZGRWUllZWU5PYlVjSnpXMk94MElF?=
 =?utf-8?B?V0JFUkpNSE9CUXVrbldqaUdzWlNYQWNHQUh3VmR2TlJTZkh1NmlQTEFUZWJX?=
 =?utf-8?B?UWhSWUEzeFFIWFJ1Q05VazBsTkt4cEdHOWhYQjBKWUVobmRHWTZUTC9YUm1a?=
 =?utf-8?B?RUcyNUlPZ1ovVlFDamxBVit1RlNTS1l5NnlyL2tnNHNGV1l6akhtc3dFMUJB?=
 =?utf-8?Q?asqYUQBDz5Df3CdXejbyzpyWngpbu8AqL4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 13:23:04.2576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f611e1eb-9a3b-445f-d1ce-08d89dd7e418
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0zvGgjW2y4SxkCVQ0rXSz635p4GxF7h9nGiDD5CImjX6qn4wtMwoijUty05ahTS7ZXj5N8/0GZbyzZXY/Dr0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/10/20 10:13 AM, James Bottomley wrote:
> On Fri, 2020-12-04 at 15:31 -0600, Brijesh Singh wrote:
>> The SEV FW >= 0.23 added a new command that can be used to query the
>> attestation report containing the SHA-256 digest of the guest memory
>> and VMSA encrypted with the LAUNCH_UPDATE and sign it with the PEK.
>>
>> Note, we already have a command (LAUNCH_MEASURE) that can be used to
>> query the SHA-256 digest of the guest memory encrypted through the
>> LAUNCH_UPDATE. The main difference between previous and this command
>> is that the report is signed with the PEK and unlike the
>> LAUNCH_MEASURE
>> command the ATTESATION_REPORT command can be called while the guest
>> is running.
>>
>> Add a QMP interface "query-sev-attestation-report" that can be used
>> to get the report encoded in base64.
>>
>> Cc: James Bottomley <jejb@linux.ibm.com>
>> Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
>> Cc: Eric Blake <eblake@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  linux-headers/linux/kvm.h |  8 ++++++
>>  qapi/misc-target.json     | 38 +++++++++++++++++++++++++++
>>  target/i386/monitor.c     |  6 +++++
>>  target/i386/sev-stub.c    |  7 +++++
>>  target/i386/sev.c         | 54
>> +++++++++++++++++++++++++++++++++++++++
>>  target/i386/sev_i386.h    |  2 ++
>>  6 files changed, 115 insertions(+)
>>
>> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
>> index 56ce14ad20..6d0f8101ba 100644
>> --- a/linux-headers/linux/kvm.h
>> +++ b/linux-headers/linux/kvm.h
>> @@ -1585,6 +1585,8 @@ enum sev_cmd_id {
>>  	KVM_SEV_DBG_ENCRYPT,
>>  	/* Guest certificates commands */
>>  	KVM_SEV_CERT_EXPORT,
>> +	/* Attestation report */
>> +	KVM_SEV_GET_ATTESTATION_REPORT,
>>  
>>  	KVM_SEV_NR_MAX,
>>  };
>> @@ -1637,6 +1639,12 @@ struct kvm_sev_dbg {
>>  	__u32 len;
>>  };
>>  
>> +struct kvm_sev_attestation_report {
>> +	__u8 mnonce[16];
>> +	__u64 uaddr;
>> +	__u32 len;
>> +};
>> +
>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
>> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
>> index 1e561fa97b..ec6565e6ef 100644
>> --- a/qapi/misc-target.json
>> +++ b/qapi/misc-target.json
>> @@ -267,3 +267,41 @@
>>  ##
>>  { 'command': 'query-gic-capabilities', 'returns': ['GICCapability'],
>>    'if': 'defined(TARGET_ARM)' }
>> +
>> +
>> +##
>> +# @SevAttestationReport:
>> +#
>> +# The struct describes attestation report for a Secure Encrypted
>> Virtualization
>> +# feature.
>> +#
>> +# @data:  guest attestation report (base64 encoded)
>> +#
>> +#
>> +# Since: 5.2
>> +##
>> +{ 'struct': 'SevAttestationReport',
>> +  'data': { 'data': 'str'},
>> +  'if': 'defined(TARGET_I386)' }
>> +
>> +##
>> +# @query-sev-attestation-report:
>> +#
>> +# This command is used to get the SEV attestation report, and is
>> supported on AMD
>> +# X86 platforms only.
>> +#
>> +# @mnonce: a random 16 bytes of data (it will be included in report)
>> +#
>> +# Returns: SevAttestationReport objects.
>> +#
>> +# Since: 5.2
>> +#
>> +# Example:
>> +#
>> +# -> { "execute" : "query-sev-attestation-report", "arguments": {
>> "mnonce": "aaaaaaa" } }
>> +# <- { "return" : { "data": "aaaaaaaabbbddddd"} }
> It would be nice here, rather than returning a binary blob to break it
> up into the actual returned components like query-sev does.

In past, I have seen that the fields defined in blobs have changed based
on the API versions. So, I tried to stay away from expanding the blob
unless its absolutely required. I would  prefer to stick to that approach.


>
>> +##
>> +{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce':
>> 'str' },
>> +  'returns': 'SevAttestationReport',
>> +  'if': 'defined(TARGET_I386)' }
> [...]
>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>> index 93c4d60b82..28958fb71b 100644
>> --- a/target/i386/sev.c
>> +++ b/target/i386/sev.c
>> @@ -68,6 +68,7 @@ struct SevGuestState {
>>  
>>  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
>>  #define DEFAULT_SEV_DEVICE      "/dev/sev"
>> +#define DEFAULT_ATTESATION_REPORT_BUF_SIZE      4096
>>  
>>  static SevGuestState *sev_guest;
>>  static Error *sev_mig_blocker;
>> @@ -490,6 +491,59 @@ out:
>>      return cap;
>>  }
>>  
>> +SevAttestationReport *
>> +sev_get_attestation_report(const char *mnonce, Error **errp)
>> +{
>> +    struct kvm_sev_attestation_report input = {};
>> +    SevGuestState *sev = sev_guest;
>> +    SevAttestationReport *report;
>> +    guchar *data;
>> +    int err = 0, ret;
>> +
>> +    if (!sev_enabled()) {
>> +        error_setg(errp, "SEV is not enabled");
>> +        return NULL;
>> +    }
>> +
>> +    /* Verify that user provided random data length */
> There should be a g_base64_decode here, shouldn't there, so we can pass
> an arbitrary 16 byte binary blob.


Agreed, I will make this field base64 in v2.


>
>> +    if (strlen(mnonce) != sizeof(input.mnonce)) {
> So this if would check the decoded length.
>
>> +        error_setg(errp, "Expected mnonce data len %ld got %ld",
>> +                sizeof(input.mnonce), strlen(mnonce));
>> +        return NULL;
>> +    }
>> +
>> +    /* Query the report length */
>> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>> +            &input, &err);
>> +    if (ret < 0) {
>> +        if (err != SEV_RET_INVALID_LEN) {
>> +            error_setg(errp, "failed to query the attestation report
>> length "
>> +                    "ret=%d fw_err=%d (%s)", ret, err,
>> fw_error_to_str(err));
>> +            return NULL;
>> +        }
>> +    }
>> +
>> +    data = g_malloc(input.len);
>> +    input.uaddr = (unsigned long)data;
>> +    memcpy(input.mnonce, mnonce, sizeof(input.mnonce));
>> +
>> +    /* Query the report */
>> +    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
>> +            &input, &err);
>> +    if (ret) {
>> +        error_setg_errno(errp, errno, "Failed to get attestation
>> report"
>> +                " ret=%d fw_err=%d (%s)", ret, err,
>> fw_error_to_str(err));
> report should be set to NULL here to avoid returning uninitialized data
> from the goto.


Noted. thanks

>
>> +        goto e_free_data;
>> +    }
>> +
>> +    report = g_new0(SevAttestationReport, 1);
>> +    report->data = g_base64_encode(data, input.len);
>> +
>> +e_free_data:
>> +    g_free(data);
>> +    return report;
>> +}
>> +
>>  static int
>>  sev_read_file_base64(const char *filename, guchar **data, gsize
>> *len)
> James
>
>
