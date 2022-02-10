Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C565F4B0D6E
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 13:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241506AbiBJMSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 07:18:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 07:18:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D864B54;
        Thu, 10 Feb 2022 04:18:03 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AC9CLd013346;
        Thu, 10 Feb 2022 12:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Tus0124XqOoj0fvHq9TmPa2z5itSeMn54MsAmqMBUbA=;
 b=Mge+M6wOHtqWPhQ8/j+UEmLLKrd6gYl91qjPRNzq4q/QoR6Xfie0zj8tvGvf1jFAbM1S
 ZXtDNMraCu9Tsp/1FqlJR8Lf59RIOpdfQJxbrvyNeIfornHwJSNhRIJlWPEo/aULanYb
 9fXHmPNQNrRgFLyPzkS7fgOFEgaPcGvl9h1yztgv3ECpzf4lPLBlfkT6RdZ67GZNpE4o
 CMPmFDZsQGOHPQGBaWVpZac/D6bZEGx4QZIGZexrPzmDI2NgkfQC7K7ADu7TJ0j+P9Jv
 0OWR+xo61m4QxkZ4H/XdAlGFkRDJFkM+MFwGe4bHIorAt56NTzm9FsvZydNy07xzLtRw pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368u0wq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 12:17:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21ACGp3u167374;
        Thu, 10 Feb 2022 12:17:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 3e1jpv4q7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 12:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9DUDjKRf3zBBQ0dY1xP+L9XQ0r6wi1+VfdknSYqSFXcMMWigPMINv0XaxPl/5Xrg5Xp6xokjzsukcqtDYROaSRMiGxW7Ck0MVenaoQE+5oJtc9rdUIE5V+56Ngo+qJPdwOA1z8C/9g6pG7zskTNYCbG6y2M4NHOOYSW86Bb0rpmn1YBb3/zjOluCsAJHjQoHXso+5Lb20tdF7cILDEiYT/OfSnmFptZvjwjueCgo5vOfAfspkF6PZnk3+zHLir72nXLgUrg2okHrvMbeyKn2HYcXwfZlbzthibILbGd/dLgVUXSF8YxI82NmXiLhcmnAqFaHOMNQyxYOzjrUeB50w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tus0124XqOoj0fvHq9TmPa2z5itSeMn54MsAmqMBUbA=;
 b=dn6GkY5MuKAtBUuqXoiZsSRgYgLujt1htfbVIokMFN+7kouEQ49i5T1+4Hu+peNMbDe00J0JH19WG/SSR2A1N4JvIUgCg4aYpRFb6O19hBp8xO2Q4UH2Q6IJIFplzvkoxulRZn3yxXKdZ6qbGsEYSQXmKTrOpEgV8uVaXvkN6AobrGJfI4aB5IQA5rmJz14x+fQdMk7eY46drI2Qqt142e2SxYqtZdDlZToqlOrFv6EaqrqMaS6rRQyuF78TQaqAGNzJd3vsS+slIlv3D9rRpvew7lHOgbv47gVyFW11vgC+ZbfRCt/fIl/kiL9jjIiemZlEV2iQ5/S/bXp94Kka6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tus0124XqOoj0fvHq9TmPa2z5itSeMn54MsAmqMBUbA=;
 b=opOVmbZjD6I4jSgijScNU0o7OptdkrC9XQzh8rmZ0ExnYof5CewRtafr2kXXH2RhrxHE+26cWkog7ofY3oiqf/Dx7s2kfx1Hcu+4uhTzccs5r47wNLB98jEw2Ne9cKyiBnjpTHbfOdqAIODTwAFOe7N4kR5/M5O7gvJei620ReI=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2651.namprd10.prod.outlook.com (2603:10b6:5:b9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 12:17:21 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 12:17:20 +0000
Message-ID: <97b17522-ec57-3ad5-b9cf-037835158e48@oracle.com>
Date:   Thu, 10 Feb 2022 12:17:12 +0000
Subject: Re: [PATCH RFC 15/39] KVM: x86/xen: handle PV spinlocks slowpath
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, metikaya@amazon.co.uk,
        linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-16-joao.m.martins@oracle.com>
 <ce716485bb0b3097cefb77c1ec53e1834bef2e06.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ce716485bb0b3097cefb77c1ec53e1834bef2e06.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0062.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::26) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4082cc3a-d7ca-4e5b-e1a8-08d9ec8f495e
X-MS-TrafficTypeDiagnostic: DM6PR10MB2651:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB26516AF8C0BC0E4BC060BFA4BB2F9@DM6PR10MB2651.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EfCfUb09sg04YAEedxy/O5FjWH6iXhCYGm9P5iLN1SFmXwubLsY9cpPO5TPvKR0ai0OOHIYkqGv0p/sH4OMwRPCCcRZnCxdJX1mZvU8oAMLo+obdqVRgEsrx5UZG9S48ziCF9LIxuPtS7rXjWZsb589kVGNqv0aAnFwQj8vAGYkPyOoUVK29HnWRiodyoUdGNAesWBGWlKPtuhrr8PK0Tr/ky9/8ern0I6V/KQ7s5HpNJpXvUMbX8xrnx7h3+Oo0ldGYhhRi+FywsQs2aBwROQFt9pCkiFyGCdfHWkzHlDBLt6nrR7bc4vke06dRynLSQZDgGRioh2kKCLGnEe4Pak1SJL+vK5/9c4M+f/JXUhAjkmWS9pCIulPL0EumuvrTTOqwshlKsnDGBzEQLJXCOQI76WCM3OyhL8MgZg7S1uGeNTcgJiyvNVwsT9gYJNQ2lZCWbh/Q3jJ1YBbXzMZx+h6FtWJ+4Dy6TM9+6ik+JC0xFcjGSMo2j5ZbD5q5JhTPlWqTYyc/N5R++lcHMtm2zVgPpaOrhGUN+s9n1l9ufPy8YfiAD0Q66aElSXK4dHEgScITQAeEC6iJsQ5HsFMp2d0Wj2LM8D1Wn7fTGoFAcKK8qjZfd7+PhFbGpbsJrnrn88xJEGq+xI6xPLwj++NcMKW2bMR5WiiAHhXyXxjC9xMMH9LVI1rwC7GF1j6ssSzKx9MKbcxwMBIzNKyPk6luzdt8JA7aLmfNqx6RZqkKxa76T78WZ8nfoAsKNlsWC7CJlLU1dbXZlpbGuminCUUZQTBEW6RBgyjbnkcdG5WcKgA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(31686004)(186003)(66946007)(26005)(6512007)(53546011)(6666004)(316002)(86362001)(6506007)(2906002)(508600001)(38100700002)(8936002)(966005)(7416002)(6486002)(5660300002)(8676002)(66476007)(54906003)(6916009)(31696002)(4326008)(66556008)(83380400001)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXl1clo2czNkOW9nclpNcENmSlBXMnFvSnVtd25EODFKVGZFR3JsZTlWRXY3?=
 =?utf-8?B?NVVtVzFuWDA1NjEwNXRBNTdMUlREZ01PMzNwWWJxaDVydk5UeHIrOXZmblE1?=
 =?utf-8?B?RVpIVktEV3N6eXpGNDM3VXNSL0RpVGV4Rld0c1BIZXNDbWM2M1dUOG1RZW9v?=
 =?utf-8?B?UTllM2h6WEN2WHhUd0ZFUHdFYTdMUlY0RDU5Ny8vOW1zYW9lUXpvT2xSUXpp?=
 =?utf-8?B?S21xR3FqYytYUXNhVE5rMEszNmM0a1RBVkkwcXZuOVFHbCtrL3JhTmRBc2g5?=
 =?utf-8?B?MnB6dGptakhTME1BN0JrNlE0VTdUTVhXVDBJWWNlQlE1VFExNG5SWGxoZ0Fq?=
 =?utf-8?B?dmpjZ0c2SVNUTi9QbWdTdEFwZWVEOHdqWjcydkQxcUxEM2JCMGY1ZTl6ZDIw?=
 =?utf-8?B?alpOUE1rRkdkRmFidDRYdnJudWxBNXNmYTM5VmJoNEE2RzJycml4a2MzOXNz?=
 =?utf-8?B?WkRZLys3RTNmcXo2SnYxUHdMb3N2ZjZINis3WEkrV0drL294RzFJT0owNStZ?=
 =?utf-8?B?SWFGUnd1bFF3RDN1VkxWOUtFMXRzN1QxNmlQTG9teWZRZjZySHRDUUUxL1Vs?=
 =?utf-8?B?ZVRwU240bloxYllvdGgwekFJdEVBcGl5VzlMdUlLYU5YNGRnWFhnYk9CVFk2?=
 =?utf-8?B?SWNTN1F3aHBSc2ptNkY4dUJ4UmdaTHZCZDJQTS9WQk9PRHo4enhvRDlNVEZ2?=
 =?utf-8?B?TWswZUJkTGRlMmNxam1lUm9GZ1MrS1RRR3B4aE5SUG1wT0NvOEdQakVWUGJQ?=
 =?utf-8?B?Nzk2TUJUTHdxT3V5em5BS0VGMk1XMmxXWnF2YTk5aDR3L1c2RE4zNUN2b1Vr?=
 =?utf-8?B?UUhTdG5FWGRld2xMeGROSlJGZUJWL2tIdkt5SHpyMVVPd2lsdFVCMVR0VE1Q?=
 =?utf-8?B?QlJDOFpFajNwd0RJdlJVbWR3K3p5U3U2N2RyU0Z6c0ZQemRtK25GL2FtWTRV?=
 =?utf-8?B?Qm83eERvQnBVelpITG1vMnl1RzhQd1pWL0V0aExrWFpQUk1NRUZEVEZaVDFU?=
 =?utf-8?B?Sis0TU1VT2RoK0c4TTh2T3NMd0RiY2JMWkZuVXVCOE5jQ0JIR2w1cUJ1dE9U?=
 =?utf-8?B?cmtCYkhURk15VXJ6akt1RUp4NTIxdmVscGVBbkpYbE15TTNOVEZjL0QweWVl?=
 =?utf-8?B?clJISHA5UEcyaVI3UUZncTg0WjJXckcxLzg3Y0J1UXlJejh2dmNxVkdmOTVX?=
 =?utf-8?B?OTBuZEt3aFNRejVCdzRPOHMrRkJ3Ym1nbnc3V2JwQmJTT0NxdnFIYnVONCs0?=
 =?utf-8?B?dFh5RmpJeE9Od09MYWlVaHpNSG10Slh6NjRDSUFGY0owcHpNY2NpT2o1NG0r?=
 =?utf-8?B?U1RuK3NqeEE2bDBpdEZLN2FKTVFkTForQ3ZpcTdTbjVWN0hrNm5NL2xFQjdx?=
 =?utf-8?B?bS9QZzVSdXp3YkRIZVJRRFBzNW82dG1OWGQ2SlZIS0gyZjZubzVCamJmSDBk?=
 =?utf-8?B?M0tLejh5cCs4dEVsVm92akVGNFRkZ2RiSXRNVDI4N3FIaDdlRUhlUVZ0ZjRV?=
 =?utf-8?B?emgwTDNmOVJiOHFGR0JyQ2FvSTFIcEFQUWk2c1ZsS0hPZ0M2S0dFeWRiM2dy?=
 =?utf-8?B?cHVmUUNzN3hiVGxuS3REWE9tc0xHQW15OEZmR0FyM2RWbXRqdEpwc3M5eHdK?=
 =?utf-8?B?TFRlaitaQjIvZmNjRXcvaHp4dVo3U1BuZXJRYnVxNEs5OXhzZEtobzg5RGNl?=
 =?utf-8?B?VjZ2VE9kRlVKSnB3aHBOOTh6SjRhMVBLajc0T2J4VjhhSitZZThkaTBNRk1H?=
 =?utf-8?B?ZlZWMm5mRFg1dDZrVWwwdDhVTDNuUWhHVTRsMDA0cVVjTVNjSVk4YjdFZjJt?=
 =?utf-8?B?OWhjV2ZvMUJXL2N3YkRjYnFKREw0YzAxbGZvSTNxRWw1OUJWQUZuaEdtamdE?=
 =?utf-8?B?V1lLVzBoR3lvQjBpWjZvTFFXMmdPMEhGWTBZUms3ZitTRWxML1FDalNqdllG?=
 =?utf-8?B?dEFlOHJyV2xWRWZqVkgybitaZnEyMGpzOHdMLzE2OFVZbTIvNE9RNnZpQjRv?=
 =?utf-8?B?bmFEOUk2TEFmNWNnVEtQalRDQ3lMdFhhWkdENGxQK29PUHo1VGI1OEhtNTFk?=
 =?utf-8?B?MUs0UExmSVhHTmp2OUxQcDUvaTRWamVjbUppbVgxRTkvNy84cGNqSm5JRTFI?=
 =?utf-8?B?ZHNwV1Z6UkVUeDdrcExJN2lsUmg3bzVtWkVBVnVFRWpYMTlsMWZ3V1EwYXRk?=
 =?utf-8?B?d3IvMmJZem1uS2luNmsvdlhsWGZnRzNwWWRvSUVqSmlnaEFsTU45TEFwb2R1?=
 =?utf-8?B?WUxobXNBME1aUlRtWHlNakpMTitBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4082cc3a-d7ca-4e5b-e1a8-08d9ec8f495e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:17:20.8819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8U4GrF33bdAP55xL7FN2S1vLj6PbLaIA9HZz3XaNIz0EC/iWBpYwJAzIRtssjDmpNkv7+1ixHIoU2ynMgTVAhDE0dEiuYpdun56+xwMZ5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2651
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100067
X-Proofpoint-ORIG-GUID: EwRclCI1NL68tWvKy43i54wBlMZjltJY
X-Proofpoint-GUID: EwRclCI1NL68tWvKy43i54wBlMZjltJY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/22 12:36, David Woodhouse wrote:
> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>> From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>
>> Add support for SCHEDOP_poll hypercall.
>>
>> This implementation is optimized for polling for a single channel, which
>> is what Linux does. Polling for multiple channels is not especially
>> efficient (and has not been tested).
>>
>> PV spinlocks slow path uses this hypercall, and explicitly crash if it's
>> not supported.
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
> 
> ...
> 
>> +static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
>> +{
>> +       struct kvm_vcpu_xen *vcpu_xen = vcpu_to_xen_vcpu(vcpu);
>> +
>> +       if ((vcpu_xen->poll_evtchn == port ||
>> +            vcpu_xen->poll_evtchn == -1) &&
>> +           test_and_clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.xen.poll_mask))
>> +               wake_up(&vcpu_xen->sched_waitq);
>> +}
> 
> ...
> 
>> +	if (sched_poll.nr_ports == 1)
>> +		vcpu_xen->poll_evtchn = port;
>> +	else
>> +		vcpu_xen->poll_evtchn = -1;
>> +
>> +	if (!wait_pending_event(vcpu, sched_poll.nr_ports, ports))
>> +		wait_event_interruptible_timeout(
>> +			 vcpu_xen->sched_waitq,
>> +			 wait_pending_event(vcpu, sched_poll.nr_ports, ports),
>> +			 sched_poll.timeout ?: KTIME_MAX);
> 
> Hm, this doesn't wake on other interrupts, does it? 

Hmm, I don't think so? This was specifically polling on event channels,
not sleeping or blocking.

> I think it should.
> Shouldn't it basically be like HLT, with an additional wakeup when the
> listed ports are triggered even when they're masked?
> 

I am actually not sure.

Quickly glancing at the xen source, this hypercall doesn't appear to really
block the vcpu, but rather just looking if the evtchn ports are pending and
if a timeout is is specified it sets up a timer. And ofc, wake any evtchn
pollers. But it doesn't appear to actually block the VCPU. It should be
IIRC, the functional equivalent of KVM_HC_VAPIC_POLL_IRQ but for event
channels.


> At https://git.infradead.org/users/dwmw2/linux.git/commitdiff/ddfbdf1af
> I've tried to make it use kvm_vcpu_halt(), and kvm_xen_check_poller()
> sets KVM_REQ_UNBLOCK when an event is delivered to a monitored port.
> 
> I haven't quite got it to work yet, but does it seem like a sane
> approach?
> 

	Joao
