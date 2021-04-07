Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021F6356D60
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbhDGNfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 09:35:22 -0400
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:18209
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235738AbhDGNfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 09:35:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPNkOcZ+5o7zaKP0q+Jb/+EVjl6wi3KYZtXfIyNI3RG4pkUBCKeIZqOLmtIsJZ6AC5P91inmfGoFMUaWMqUFcwuZBDk86LIoIhCxgvLO5op3u97I/YbovECjLD0Uw5kdGi99IvC0jfiFoGprTWwGEC3Cw6MoelUr8B3P4EXElT9M5qyQLuZ3/WIln5hBN0slAr++qLB46hLENRPZFJh63nC/zyuf17kIlqmdfR2PKeLETDd3aBAWDmngKZ2ZNQHmIw0nM0xybU3VUek8odZBPrFNJ6rpGQflAlg/hNd/4WW3zRnu6jmL8nk2ELjzQYTfQpw7V7ybpJOu1rM1o3BFAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bebo47eWZfaIOJ0GGmYFJqJbUizQUTSDTTCO18RBufs=;
 b=i0LcPeDEBQevXem9Zx16Pcn2L/Zz6ollGhs8lXRXSCfkDPPo/jwYFmtmbY6eNstFlE63rWZT7buBuLK3iYwl9jxQlPh8BVolUoyn3/z6mBSBwhrGL5zPr5EblnXhd0RkzrAvjsPv0iNDr57Ius7hBFWSYXY6eGcVi/RiHTjCM7wxRfwNjMFts16kCSPFLFAF4LEeb9VrIY7mJg4d8dw37mHkWNoCV3G7HiuJUwsvyvWJs+BO3Usqb5OEUlPVuyy8L94NvoXwZCmHB/Iu+Hd4pkD0/2vdXR5+UiS9UWZmSktWYFMe1HzfRAwkaah78pFfCqSi1K6Buuzl94424G/ORA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bebo47eWZfaIOJ0GGmYFJqJbUizQUTSDTTCO18RBufs=;
 b=ahTmg9JKh95qdMSq4Womqj2Tbk2SeO3GklyS+wQAUPH8dbsmnGfrzA3qopy5FjJeivIp2PAGP/wbMDroBScbyk4xpuaCuTb5MrsOjEI8JYOwnjy3Zplzm3tf42Aj1N8QrA8d7LZIfRuMHEUiAIITz0dxUYcgvtmal8pqm54IXZI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Wed, 7 Apr
 2021 13:35:06 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.017; Wed, 7 Apr 2021
 13:35:05 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, ak@linux.intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the
 memory used for the GHCB
To:     Borislav Petkov <bp@alien8.de>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
 <20210407111604.GA25319@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9f43f7b2-d9aa-429e-eadd-dc3ea4a34d01@amd.com>
Date:   Wed, 7 Apr 2021 08:35:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210407111604.GA25319@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SA9PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:806:24::19) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SA9PR13CA0104.namprd13.prod.outlook.com (2603:10b6:806:24::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11 via Frontend Transport; Wed, 7 Apr 2021 13:35:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2862c218-d2be-4d96-706c-08d8f9c9f431
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432E4713108AFCFE02466BFE5759@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pn70IEoTRcIItMdN7mCkauG4RDu12FIqMk1KTFPqnzIGJgzrgut9jKM0CwuU+WLBL47noxER+qUkck0mTMnJjKOK+EA9mT+AI7wAWpThAFH/MBOAAr1MI3Xg8PEuwAUNWsDtD8CmPeoCCd6q5itLhUC/h/pCQRhRmEu2Irc0zY/QF6Ltb/YvtqAaUECW1yQvNff6AsF+yEN5veYt5OXLkrDlOcFE43EItyrv2Rp8wjrXS+EBwxeZGy2PEQtj70dFCTS0GL4BJLoh3D+tTWzZJJmz7eaBVLyXilUJG9qpqlwr7436o0whVfv3/F7EWXTtz8Ynji3kyyEyowtDt8ndNu6hzeEhJ+D0w9MW9V9HC5ZQFqZXJk72ihjLwkbeq7/Y04yM0pTZqQ637XA7+HlQDZkwEBuL6xwv55goe4NwlM7iuki43Q4FqCRDXOJ8aGvz1aleCF+nEaHgZ5txkD/YpR58Ga+yg5u/1CEBMJLuvFSbEUX7QgfMz50dkBEnuZiGJEHAv1Nd28R1pRSZvc2KVGn2K2EXM3B2PvKc6vJhyUb8+73xRKjuI62FARn69wMxdXBIZgc2EklLProQ1GL4CUYc6DRWv8H5RuWHRUDbaz4TmoSJyq2QeDP+NbTJvThaBWB8HdVSkv9qhyVqlBkaWImedkJmlGz7dT0M9JCJtDR6cjK87sPTMTYCHfzwB8PHkEtvOm8uKvk0uXLpEwoZgseGcNLF85hRGFTJf4lyfCSO/o5X1HbkTYtJyZ6Hbdya
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(66556008)(8936002)(66476007)(31696002)(2616005)(66946007)(7416002)(6506007)(4326008)(86362001)(316002)(956004)(6486002)(5660300002)(83380400001)(478600001)(54906003)(38350700001)(31686004)(6512007)(6916009)(44832011)(2906002)(38100700001)(36756003)(186003)(26005)(16526019)(52116002)(53546011)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TkRUbTFoeFliQmdlbGpqdHVoS1poSGdVSXU5RjhrYWhPanRJMGdJUmdUWU5r?=
 =?utf-8?B?cC9PQTgyeFVWdnpYT1NNTHRJR05UdU9FNDdHaVdtQkxqTjNldTVBM1RBOEZs?=
 =?utf-8?B?RTExNkVnZENKN0FYNlZoM3RWVzVFZ2tiR1loMnpSNmFRTXNuU3hWQlM4WDYw?=
 =?utf-8?B?eVJ1UlI2dFNobE5LOFRqWWZOMjlBcDZ0OUZ2dXpJeDZJV0Y1NzJJRzJWL2dt?=
 =?utf-8?B?aWNtdThocHVYdTgyVzVZbElKR2cxWHpBKzBRUFlhZzVpRzE2SkpyOG9UUFht?=
 =?utf-8?B?V1dRWHVQR3dLbTh0YW0yOGMrMU5MVmtSdGNDZG9HaXFWSER0OWtLa2Q4Rm9t?=
 =?utf-8?B?UjR5UytkUHpWaWdCR0d5dkNnQTdxZ0xuczRUNU1XWDdMeTU3bXRvTjlnQU9v?=
 =?utf-8?B?YWZOM3VJczg0MXFDUlBEeTI0VHdKZGM2OHhCYktraWh4WTljOVV0OTNUZGJX?=
 =?utf-8?B?bWRVTkh5bVk0VXJMRlljSUcvb0hZTjRmSW9rYUJjeWNRbFZSci9HbW9ldExB?=
 =?utf-8?B?VkNpZ3hqTHZJOGppNkhadTBMd1lSQW9ZUm14UEJrQncyMS9WbklXbGFXNDJ3?=
 =?utf-8?B?Z0FnM05HeFhKSDZRb0xBbVRGYzZqNXJSUEp2YzJaS1FEdkNRVkNSQjZUSTUy?=
 =?utf-8?B?RSsvU3hFVnpocW5jTnp1YmVXL1FhYzNVOHBwMHZjUlBxd1p4ZmpqN2R1SnVG?=
 =?utf-8?B?a1dsczIzYTZsY2craEJwOEdoTS9zVGRxN3d3TVlLMFpUR1dXRDhWV0ltcUZo?=
 =?utf-8?B?enRvbmNzUm8wN0xWWnhiQStWM1g1NFhSOFM5VG5WNjRYdXVjWEtreVVMNTFZ?=
 =?utf-8?B?U0FOUWhqOHNYaEFYRHJ1MlVacE0xMi9LZmFhNjNzNFRPU00zMEoxNm9neGll?=
 =?utf-8?B?eEUvNmE5ZDVRTjVBUFpkV3ZuRnJIRTR4SHFyWFhEQXJLN1h2Sm5TQ1o5U29C?=
 =?utf-8?B?eUI0WWtmR1JEV1FFUnpGbG5KWVVSQXZxZGZ3cE1VQUxoWC8zV3czaVpKYXlX?=
 =?utf-8?B?eFJYOWpUNElTbGkwamNRUTdLYmZZWm5pa3JrYnZGYTBkd0RNNS9RVCtLYWsw?=
 =?utf-8?B?bCtxN05JSG5scWtHd1VQVkhidmFxOFg2b09LcVVINTZwcFFINVhTTUZmWi9C?=
 =?utf-8?B?NjdXMU5reGhjMDMzWGdkRmMwdGV3Z1JGOURKYlkybkZOUlljb3c0ZnlxVlpa?=
 =?utf-8?B?NktPVmRUdEliQnJwQVF3eGxob1J4bk5nZmJtR3VJQ3VlYUJrbTU2aVlXQjBj?=
 =?utf-8?B?SUZiVnNkSkhsNkRFckxIa3F5Ymg5bDc0QU9ISHFYSFdqQmdiRStmRXFFY0Vv?=
 =?utf-8?B?Rjd0TnlaSGJZVytSVVEvV0VEd2FmVkxyd2I4eFhIdnZxTGdVaisvcmVla3Nl?=
 =?utf-8?B?RHcydEpTS1BKbEloTjFEY29WaDNBNU5wWHFOajR1SUdwejBCSlNPYmhiWUFx?=
 =?utf-8?B?NExGYndIREhvQlFTcHlaamh6MGlVYlFtemtJNENtR2FnQVVxTUlJTzArcmNY?=
 =?utf-8?B?TENJMkZ2MjZqcHJ2WGxXZUpMQjNVV0xQN3kvQTRMN01WU2Q5UGJZOExnNUFT?=
 =?utf-8?B?emtWR2xCd3ZZM1kvbmloN1V3MWZEdEZUakVTVm43R2V5NzdBOVJKTmhxcGR6?=
 =?utf-8?B?NGNnNDFDYklEQTFTWnBocWtGeEhSZS9BeG96ZWxNSUIreUhVWGN6WWcvUHJq?=
 =?utf-8?B?c0h4WWUvcUtKVkhoSUY4V3ltc1FZVUMzSmxuYURyUTdVZjZYQktuWVIwUGhC?=
 =?utf-8?Q?GEzMIAlAyhKw0Q82CSP5xpvtd8wdnukmugsEW1S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2862c218-d2be-4d96-706c-08d8f9c9f431
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 13:35:05.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOrYSiKjVrpruTE42g/pw5l8WTc3Dy7Srs20BOi1q4UX+Kpp96O8qlmIGXd/LE80FlMd99/B8DacZ08KOFQArQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/7/21 6:16 AM, Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 10:47:18AM -0500, Brijesh Singh wrote:
>> Before the GHCB is established the caller does not need to save and
>> restore MSRs. The page_state_change() uses the GHCB MSR protocol and it
>> can be called before and after the GHCB is established hence I am saving
>> and restoring GHCB MSRs.
> I think you need to elaborate on that, maybe with an example. What the
> other sites using the GHCB MSR currently do is:
>
> 1. request by writing it
> 2. read the response
>
> None of them save and restore it.
>
> So why here?

GHCB provides two ways to exit from the guest to the hypervisor. The MSR
protocol and NAEs. The MSR protocol is generally used before the GHCB is
established. After the GHCB is established the guests typically uses the
NAEs. All of the current call sites uses the MSR protocol before the
GHCB is established so they do not need to save and restore the GHCB.
The GHCB is established on the first #VC -
arch/x86/boot/compressed/sev-es.c early_setup_sev_es(). The GHCB page
must a shared page:

early_setup_sev_es()

  set_page_decrypted()

   sev_snp_set_page_shared()

The sev_snp_set_page_shared() called before the GHCB is established.
While exiting from the decompression the sev_es_shutdown_ghcb() is
called to deinit the GHCB.

sev_es_shutdown_ghcb()

  set_page_encrypted()

    sev_snp_set_page_private()

Now that sev_snp_set_private() is called after the GHCB is established.

Since both the sev_snp_set_page_{shared, private}() uses the common
routine to request the page change hence I choose the Page State Change
MSR protocol. In one case the page state request happen before and after
the GHCB is established. We need to save and restore GHCB otherwise will
be loose the previously established GHCB GPA.

If needed then we can avoid the save and restore. The GHCB  provides a
page state change NAE that can be used after the GHCB is established. If
we go with it then code may look like this:

1. Read the GHCB MSR to determine whether the GHCB is established.

2. If GHCB is established then use the page state change NAE

3. If GHCB is not established then use the page state change MSR protocol.

We can eliminate the restore but we still need the rdmsr. The code for
using the NAE page state is going to be a bit larger. Since it is not in
the hot path so I felt we stick with MSR protocol for the page state change.

I am open to suggestions. 

-Brijesh

