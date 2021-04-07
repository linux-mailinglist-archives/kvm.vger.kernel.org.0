Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFB4356E6C
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348307AbhDGOWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:22:08 -0400
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:25252
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348243AbhDGOWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:22:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYj7fy+zy/2hJnHBB8ymxDLAtiXpDH113qzMc9SD7s1AsJFS9g935gZjQys1h4yVKbDSAXRA6xFd3RqbUEmmcdKi6NEMwJVSOJYhkWdzY2uhLn+nUiktfYQ2UKGBHLTn65BlzTU6yAyDsGG/zUNr67T3riAOHAUtLQYHyDqlA5K6UlS90Ji97qHlIzcnU5KuR+SDe20/8veF28SiTO04xoRHK7r17riZpSBnx1NiflY4GVbJ2Jn8C9BFeCxeTR2h/tY0u/3b9/JtnG9zEMxRybwn5Iayx3sXb1f4b1/bjdNK++9wTFBh7Rci5JyeMREKK3G9wLxhMQ9yVNdwwhRuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC43LYAPqvPESvqRERJiFWLDiAaWrZ23p7uZRLSU1KQ=;
 b=bbPcH4lFZuTyLPrYzEOx0tSZhmHd4r17aHPLuFRBNcf+9CFtGJCpc6WDxdFftz0JYxZOTyhNKSf42hJgwkfmRKu+HS+LSqhvLUU45Ln5klc93nmCYdu1+A7HeQ9xtzWgyPysSkcs44AbzU56XQNyYt0FrMsqk5AkYam1lCuFLqXonBi2ilz55CFFbM4kTGvHututbWrwGQDIV1hEDZXuMLH5oqBE9oltoI2Yp4ZL4ejftETAEQtjDK7bKobAtcbPTX8vQk0Zszno4sONTTRG0UST3xh13PICLMhZ4l+ykEQxWIeTTT2vVtXoEq+HSLRN6lOt4io9xk6Oc8fipXbU4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC43LYAPqvPESvqRERJiFWLDiAaWrZ23p7uZRLSU1KQ=;
 b=bBAVFnaZGuDXA0bZnXPUfFDBmLoB0ecPr5+KnXZU+sCTLatpaykQkfuMYV0RvkBIya3P8ENrdOfZOwWxVf6kAlJWqTcV+B4DDxLWob34qNW3eXNZeI5Vuv6Q6E8gZxksCAA0pbuFgC13qnrrLgMp940OcgSEY98Adxupp22veaE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2826.namprd12.prod.outlook.com (2603:10b6:5:76::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Wed, 7 Apr 2021 14:21:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Wed, 7 Apr 2021
 14:21:55 +0000
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate the
 memory used for the GHCB
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
 <20210407111604.GA25319@zn.tnic>
 <9f43f7b2-d9aa-429e-eadd-dc3ea4a34d01@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <205cb304-8066-5049-9952-aac930cceb24@amd.com>
Date:   Wed, 7 Apr 2021 09:21:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <9f43f7b2-d9aa-429e-eadd-dc3ea4a34d01@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:806:27::10) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0125.namprd13.prod.outlook.com (2603:10b6:806:27::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11 via Frontend Transport; Wed, 7 Apr 2021 14:21:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad89d6b6-9193-4dff-cf00-08d8f9d07f24
X-MS-TrafficTypeDiagnostic: DM6PR12MB2826:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2826A66ABC2A3C0D42D3D2DBEC759@DM6PR12MB2826.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SswLzYL1LswM7Q1o+KSdIlFbJtBZVf4eoalXW2Q2SIJWhlKfxVn901AAqEnBt/cIl8bxgi7dPH/XDW0nwh/NAk7jJhwDhjeXYF2Ub/kTe3tFfmmWXLOGC7oWOaAB2toccE6tOLm97idWGpRWjth4VJHBjDDbGMCWLCoK0WLc5PB7OAZOqdt86wN2uQf9vne3Bjcx9HB33KmDllHmT9TSVi9EUFnBQXTSvsg7ESIQ+q+iZDL5i3D5sHt+U1fV17JSVDd694iFynSwWAiZOQWSIA8HIidgaRftGNDDOPBApUZ2F+6HLH/RbFTeTLj+xJjnDREOzueiQs5HfFU3owzaN6SBTh8nQjKbyAUuiwR77bufOKod0F3wa5OmCpG5E1jFdaVELoqOstUdkQbOa5GOOCgbPgy+JPe+kZw/xag8nUFcILXhAHk/rgmVw/otTLOSX/WACYWElvAYLE4yZsJKdZpql/yf4DBemlXJxUZ/sEIhqQ8IKi5dFk6SqL728VlkSaflvN+fuYVtjOhVD3NDwSDVcWPPDCmMsw4J4jGbGSkZ6euJgf7iIXpSxoBIQv42wEHgRftT+ZGmgwa/LAWM7xzzly49jTkgDJTPhz6pZkirptK/ivBhFUoXRSMfgXhgxAHSZ0uoxux2sLTp4+D8qZ3uRnU+g/mJu9rtwjrvSHbFBoCikMloaB4XtR2X4uZ5Qj3KPZYXHpAZNaKVt1rwaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(54906003)(8936002)(2906002)(6512007)(316002)(5660300002)(8676002)(66476007)(6486002)(478600001)(31696002)(83380400001)(110136005)(38100700001)(16526019)(186003)(7416002)(66556008)(36756003)(956004)(2616005)(26005)(66946007)(86362001)(6506007)(31686004)(4326008)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MWJUQWsvWkJVZkFJbHZDZUxaRnBmb2F3Q01GTXB1TURjWklYNzZrZ25OQ0Np?=
 =?utf-8?B?ZUxzYndPZW5SendpSVVSaXZNMGkwOWRhRUhLWFZkZU55a2RzRk9Rdm1QWCt5?=
 =?utf-8?B?RWRDYUVaUFVaenllNHRSS0pDbkh4TVpZY05DMDdlU2NMNXB4MlJjS2RHMXBh?=
 =?utf-8?B?SHl5UVo5T0R2ZVJVdXhLaFlGMDIwQWhSTmhicmJuS0UwZ3pDMGp5Z3llc2o4?=
 =?utf-8?B?T05hdFRWVGtaZG9PZlZWcEtSM3VXUVdybndvdTZrK0dBYVp6YlFVNTRPRnlU?=
 =?utf-8?B?T2ZBSXFRbnRYUG8yY3ZDL2tWSFRRVU5PNzUxY0RYUDhwdU1TY2F1NTVvM3F4?=
 =?utf-8?B?b3RQc0pJc2FOczZBc2NlRlBudGJ3eUNMWU1WNmRHd1FVV3ZXTmZPaG1lRGc0?=
 =?utf-8?B?ZHdCZ25IV0lwZTM3OGNGNDF3b0E3RWhkdi8yQWFHK3BFalZ2SFdZYk56UmR1?=
 =?utf-8?B?ZEsyc2hNZ2FXK0Z4cGMyTVpGazZEUmtTTFAzODJ2Z1laOHZmbWx3R003UE96?=
 =?utf-8?B?QTkrM3lJb1Y4bG9xRFVKdm0wbkVSaFNwckJtT2l3Sm1IVlErRklCWUxTN05i?=
 =?utf-8?B?NmdicWJZdkovb0FPUHNkU2dOU2FQQ0FPaFdVUHdHRlAzY1FxVVdKM0NPd2I4?=
 =?utf-8?B?N3NmZ3o1UU45RlIrZEVRZzZqYm52a0N3ZHJ0UjF4UkpvQnIyZXhSdjhTanlH?=
 =?utf-8?B?by93TGZ5VEZyeTBPTzE4eEFIRkVjNHFOT0xMTXUxUXN1cTJBNnBBSHVld29t?=
 =?utf-8?B?bncvZllZS2JrT2dWcXUveThSYTlESm8reUQvNituUDA1MzVFZng1WStyMVhu?=
 =?utf-8?B?bTlmNVd2M2t4RkJkTE1tNWdGYWJjeHIwTUJjZi81WTZxM0FaWmw1U1FpSE8z?=
 =?utf-8?B?SUdodHVTVGlmWXorLzdyRTJYVzhBNzNqWXRSeUxuWmxFZ0FGaXNNc2hONk94?=
 =?utf-8?B?YWsrL2J1Z2ZuQnVSRWpkNlhUaEU2VWdJaHh3UHIwU3U3dG9ZNmtHTno2QS9M?=
 =?utf-8?B?Zllpc0lsRklFQ09zZjNLdkJxd2ZLYVdxdDUzV0dpNVdmWWZXSFU4bnVGdkR2?=
 =?utf-8?B?WEhucy8zWHhmY2xubDZKN0h2dkdqckxxa3dDbDJ1UmFLbFVZOHkwWWRwY2tH?=
 =?utf-8?B?eXdsUlU4WmZxRERSK3hwQmFKTHhSMjM3ME5YU1lkMEJVdnB6a2ZBMXZYNXJC?=
 =?utf-8?B?QmdGOVZncEk3RitqVWlkdURKT1NNMTRkRUxMS1pSQmFLUThzdDlwdkM1S1g5?=
 =?utf-8?B?L25WQm42NXdVdjlrU3BmNUdQdllMTVdzb2UyY2h0NjdxYXJGREJmRXZqNXkx?=
 =?utf-8?B?UUI3NElsUkJNY0sxdDRYaERFeWpJc21OWCtPQ3JhVStWaDNISVo3cjk4bXhD?=
 =?utf-8?B?cmFlZG1JNzlrVmsvTFZsYm1FU0tjUGRvblhsdTBYTisyREVBSCtnSUtGRWZ5?=
 =?utf-8?B?SmJ4bUYvUlhHbjJLb05CL3VXdmFJVWpqbVJPTUt2M2dFak5mRmh3YmpFZXZq?=
 =?utf-8?B?TGg0T1VET3J4bEM2L2cydWZoSlk1WjJPUlZDWGR0ZnJyanBUWitmVDVnaDJR?=
 =?utf-8?B?VWNyS1N0Q3NhdE1aSzVEVjJkZTlOQzh1K2RDMDhNZmtDWXVCRHczNk9welNL?=
 =?utf-8?B?TmRvelBMQmF3VkI5SGgrOXZURHBpMlRLdy81d1BGV3p0ZWZqSFZYRmFXeC9y?=
 =?utf-8?B?TW5waEVBdTQvV3pBSzhOUEdOSkQ4bHNRbUY4QWhpUUk3MFg1cUZKcVcra3NS?=
 =?utf-8?Q?u68vyttk8EMDwnctFTIQc+RLtEXAs1xLSGGBmb0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad89d6b6-9193-4dff-cf00-08d8f9d07f24
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 14:21:55.6886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSPyLmRObLPlletyOHlkJPe30Jz161LlaqKrFaaJSqY6t2ApX3goK0EGYm7kKLt18zmAflI3Su06+fe+Y07a7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2826
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/7/21 8:35 AM, Brijesh Singh wrote:
> 
> On 4/7/21 6:16 AM, Borislav Petkov wrote:
>> On Tue, Apr 06, 2021 at 10:47:18AM -0500, Brijesh Singh wrote:
>>> Before the GHCB is established the caller does not need to save and
>>> restore MSRs. The page_state_change() uses the GHCB MSR protocol and it
>>> can be called before and after the GHCB is established hence I am saving
>>> and restoring GHCB MSRs.
>> I think you need to elaborate on that, maybe with an example. What the
>> other sites using the GHCB MSR currently do is:
>>
>> 1. request by writing it
>> 2. read the response
>>
>> None of them save and restore it.
>>
>> So why here?
> 
> GHCB provides two ways to exit from the guest to the hypervisor. The MSR
> protocol and NAEs. The MSR protocol is generally used before the GHCB is
> established. After the GHCB is established the guests typically uses the
> NAEs. All of the current call sites uses the MSR protocol before the
> GHCB is established so they do not need to save and restore the GHCB.
> The GHCB is established on the first #VC -
> arch/x86/boot/compressed/sev-es.c early_setup_sev_es(). The GHCB page
> must a shared page:
> 
> early_setup_sev_es()
> 
>   set_page_decrypted()
> 
>    sev_snp_set_page_shared()
> 
> The sev_snp_set_page_shared() called before the GHCB is established.
> While exiting from the decompression the sev_es_shutdown_ghcb() is
> called to deinit the GHCB.
> 
> sev_es_shutdown_ghcb()
> 
>   set_page_encrypted()
> 
>     sev_snp_set_page_private()
> 
> Now that sev_snp_set_private() is called after the GHCB is established.

I believe the current SEV-ES code always sets the GHCB address in the GHCB
MSR before invoking VMGEXIT, so I think you're safe either way. Worth
testing at least.

Thanks,
Tom

> 
> Since both the sev_snp_set_page_{shared, private}() uses the common
> routine to request the page change hence I choose the Page State Change
> MSR protocol. In one case the page state request happen before and after
> the GHCB is established. We need to save and restore GHCB otherwise will
> be loose the previously established GHCB GPA.
> 
> If needed then we can avoid the save and restore. The GHCB  provides a
> page state change NAE that can be used after the GHCB is established. If
> we go with it then code may look like this:
> 
> 1. Read the GHCB MSR to determine whether the GHCB is established.
> 
> 2. If GHCB is established then use the page state change NAE
> 
> 3. If GHCB is not established then use the page state change MSR protocol.
> 
> We can eliminate the restore but we still need the rdmsr. The code for
> using the NAE page state is going to be a bit larger. Since it is not in
> the hot path so I felt we stick with MSR protocol for the page state change.
> 
> I am open to suggestions. 
> 
> -Brijesh
> 
