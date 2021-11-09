Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7530B449FE6
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhKIAsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:48:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57800 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235349AbhKIAsJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:48:09 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A902vuQ019145;
        Tue, 9 Nov 2021 00:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gi4omwCWikStnBVOOGZ1Qw9XggCqfKgmEeCJma7yYys=;
 b=SMXjcqUVzIhllnxrm3iKskB6LGX8B7gMi41mQd4BsBk5nvim4zG/ItGhGJt9joRvkHf0
 yN50h4YBLWhOKynfR3BPDiduak726B5Pe+53UBUxkuGpkSlThlPHY4O7guyY6Wy6SzCV
 MyNsNPu1cIvQrOmkyJanI82VBLXg5NVw5UN+a0mNOOmxAfTntnCZ449W8xMVRVhdi855
 rl/+VOvJQ8xlFaeTW2FoflUqUc1OpxyOtZGCkyVgf2yOz4PRFpgjH1Va1RfNLXfjwx6C
 82L+THgeT5T532PZtldLDR/0rBOIu9m5MeZA4tafFwrAX9UQzi5n5v5icCurajywXPg+ tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6sbk7ctx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:44:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90ab4M054251;
        Tue, 9 Nov 2021 00:43:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3020.oracle.com with ESMTP id 3c63fs5j3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:43:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l73QnIPi5zi3OIJCIDVucVRuThc087vw0A10Xmrrb0yRm3VTDDYigSRAnVLcCXYHZoQOkGzzz/K0lAj/Jl+oDgcLtEHAGyDpMSP+b6aANatVhesMCkaxXNuL7aIMLAfZJmEiAOJtodYpjyCTs31uEPPpYjN/xwOtvf0yeTExhsgpEEOH5L0CC5v3yGubT/sX36ElpXXbkWzO4NGnuiOdy3HGGGutCjuj6oIV6HcayjGPOoRs1T7Qs1X8JI2ZALjcfQ6sr1Z9ld6tZnaASnlEd+fXxCAXi3hWVRlyq6Sh3DEykXg3a0NnagQqjeqULZnOK45P2w6eilws3jbRw/dZuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gi4omwCWikStnBVOOGZ1Qw9XggCqfKgmEeCJma7yYys=;
 b=TGGpX1NiGaFD/vIaxS8amChip4O3vc0sLo+OJQiJgszS4r7uuv+JBEAYyYZKTxU2o9uLvXXeTq5Tuu4BvwDSxDmRpSXv3jGaZu+x4jwLun2ba2LomocQACnqSybGlX7qfohdMRkJyqD3qEEG96NtEp3ObBkT1qByHLqs09x5JjjGta9gb95HXaLMwav/Cvgs5+YpyGcvPXvunoX5Dv4ZU+HJpNcKBhOtn8xU1obfcGYEeQSeaLgYNHr3P7e/ApSa6lRu9i41Z8b1xCoxH0HIveDZkLyleLachV/v1F1OIRRHTg9hkl/gHBaqYmwpl3604sHEEaXIVgpONw8r5HLCFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gi4omwCWikStnBVOOGZ1Qw9XggCqfKgmEeCJma7yYys=;
 b=Imtf2NajxdgXcuQR/Uss9kyERmI1+74tXpE5tjWREGbIMFTMhxohN1xY4RjQ2JaEXgRkaJPYPATJn6gCAFOk48XVI50TDaVbr3G2SXOsBdOSSEgLkh6HhhzTAexDpeNTM3eEmVL4rCmc9/qbQb0wG/YLwOAtxuM+vQ0H/PDkQAo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:43:12 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:43:12 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 00/30] KVM: Scalable memslots implementation
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
Message-ID: <cb4f5d6e-9535-dd57-d8ee-3b593a81f3a6@oracle.com>
Date:   Tue, 9 Nov 2021 01:43:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0601CA0075.eurprd06.prod.outlook.com
 (2603:10a6:206::40) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM5PR0601CA0075.eurprd06.prod.outlook.com (2603:10a6:206::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 00:43:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0295772-27f8-442c-1af3-08d9a319e86a
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB52739339EC881A3917C545ADFF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8tPilmumMsaMapdlIA/7MpDKfZNx82L0xPCaFgKdOrbJRaKGotNtR5+/+Nsam24Ds1jUPHd09UyfU2bBRMLFsCzQ3sCggc1tXKPxWOGy9Kw73j0e10mVuSaR4jhW2EPu6aQmBf5sbmt0Ns3x75wA8WeuuxaVW84po/CkUkLXiUjn91fjkns/e2AGNVFu6S19zU4zmxp/IsSjOn6yudK1NeZsSczZBe1ffRLOJecFjRxegcWRnnUtR8BFkQ7W19k8u2dNXlHtZcZaE/Ka4JOALFxhDJMYXgxX320dnir2Svt/T9IGz9XDELqDYtt2N8G7jsI9NBTCmAnfYqdK9/Q1HRxMkOhSgiRj0gmGk9P6BRwSmT8hQtGT9Vfdxr3I3qXDrj+Q2x0fU8Zpjqsc+drtKL3Xm81mqCHl96YCgyKUgCbBUZ38b5p0djbhoZz7O4ygtBtz+pQQHR9UGIxIOZBXr4HL8+EiP/g/6P7NFR7qgWAi8Wg59ssnjUCmpDyHghAjocpD6DxQ+PGesr6ZxFzw5Y9HZDrkB+sJIKPFPT7dpblPVNtZTsCxQErMxHKFlyen0nsA8pHBFqvs0Fs8+j7B2WusIyTsPIS8Gt75n845xTcCtJ8P6qWqeD+D/0ER2kn1r26aziYmMK4Q0/Uopf0mba4nq0thqhjlWvTTusSfxl8OvuPaxMLGHc91shC+cQK06bXJH7lhCX/mT3rxgYx5UYvF6BZ6O6a+WDbj1uq6BNw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDlMb2VaWkJOM1pwQXcxbGNJaW5iTmYrMVFKYi9YVElRRzFpbW5rNTRCL2Y0?=
 =?utf-8?B?VWhSK3IrbTJhYlVWcSs0ZXBCbFFPR1FISHlkVG9lNW9mV2lCVnVwQTQ5TG81?=
 =?utf-8?B?SUhqZm90TnNqTXBSOTdSYWxSQVhwaWxhZjJZOFkvN3g1MlpjaUdCeEc2VmJY?=
 =?utf-8?B?dThvMFlRTTFFK3F2cUE1VzRNa1dFRHgrQU9tcVl1SzBMd3lGWDU3djQvVnh5?=
 =?utf-8?B?REFiU3N0dXg2WW1ORElZWGNRUlMzbmdqVWFIYVJyeU1OMG9ZQ3lFdWloaTFC?=
 =?utf-8?B?Z2d6dHFwVnRKbEdJVnV0VTM5bGRYdmRxYW5iVDVtdmUrYm9ycnlsaTVqNW8y?=
 =?utf-8?B?OXF5UEIwcHR1aUxlSFdNM0lXRDY5T3NPemJqTXlOckNWYU5UWDVpK25uWE1Y?=
 =?utf-8?B?WC9pekhIR1poTkFmT2EvTGxkQ3JZZXZ1ZE5UcDY0MG1JUEowYjNsNGROcmkv?=
 =?utf-8?B?SXo3ZURYV3l2N21hVWJZT3JGODU1UG92Yjk4QytJdnh1U3pyb2xiR3Jtak13?=
 =?utf-8?B?R25ZYmZIdmVxMEtQTThLRkN0UjkyNnl5NU9qazRocVZNVnBoYXlwZEowRWJq?=
 =?utf-8?B?cWZNV2E0WFlyMnBsTC9EaWwzRXcyblBFdjdOQzJqNHk3Ritmd2FaTDhKRWpy?=
 =?utf-8?B?eldlYUErbnArZWZNc01iTWdzZzJadTJkZjFadDZaOVI0bjVaUnFTcVRta21s?=
 =?utf-8?B?VXN5dlRuSU1HdWVPb0kyNUp0UXovRUV4R0ZJL0E4OHg0OThTWCtYeGlGb0xr?=
 =?utf-8?B?OGRPL2oycUJjaWpxZ3VrZGNvSno3RVd5S3ZjZUhnbS9SMC9ZSHhiZHllbUJV?=
 =?utf-8?B?ZjVaZU04ejFnRXpjMkZDK0xOd3RENitHeWxhYjZuZENMUmRDc3lzd0lFeExD?=
 =?utf-8?B?WFEydUl6anZTWTRWd2t3bTNrSEI1cys5VmJPeno3aXB6NlFHLzZxNnc2VkJp?=
 =?utf-8?B?bUVNMWMvd1Z0eklUN1lENlMxRVVZaVFQcjF3UHdDNFFpS0FucWVWUnNvck9O?=
 =?utf-8?B?RU9pWHpWQzR2ZjdRWlRxc3F0ay9SUFZ5cTB4Mld5bDAvZzkrcjhBVFJwYXlD?=
 =?utf-8?B?Ylg5MnVOYW1RWjhFSFhsY0g0c21mUGxjMzFObXpMK3RDYmc5SGlFU2N4RnNs?=
 =?utf-8?B?WkRkTmFEWmFIejkwSEZxdzJPRFlYMGZqWEtVVzlhQzFoU1dKQXU1eHNKYXF0?=
 =?utf-8?B?Tlp2MHo2T0VhUUJwTXRUWlFqbUhIUzZpRXNTcy9tU1FLWkFuNWZCQ1VrWUhH?=
 =?utf-8?B?NUlJd2tONXR6eXJjL3VRWnJQL0NxZUNSZWY1c2YxamxFTFlkRTF6dUpzYkpY?=
 =?utf-8?B?RUZqN29YYmFzZVdxM3E1TmF2VnVsZ29TVFdTeURMeEVRWGcyVk9LUXNvZkVl?=
 =?utf-8?B?TFhDTHQ0RWRZZ3N6c1dQZTc3VGJoKzVpbGlFeDA3RTlBcHNGRmd3NTQvQndR?=
 =?utf-8?B?ay93c1RIUTVxdE9IeXZJZnpJSTlsanpnVkJUeFRyZGpodEJzSUg4ZkFkN25h?=
 =?utf-8?B?aXRPczF1b3dSSjZuaXd1cGp5L1pCTzR3ZndKSDUrZjh0aXk3VWJocWY2a2Zv?=
 =?utf-8?B?WUZXQ3lPM1pZdFZBanNaMmQyb2JZWTVsS2o1WEU2WTZ0dmUwV0gycmdEY1pp?=
 =?utf-8?B?aUN5U24rTWc3dmgzdjNvS0lyQ0FiK04zRjdMWEZqTEV2ekxZdXU5dnJqNHVT?=
 =?utf-8?B?VUd6d3RmdFhnSUp2dWdkU1luMzZvL3doS0VPaDFZRVNrMjQrZ1BCYmJsZzRu?=
 =?utf-8?B?dkw3M0RZd0daRXlhcW40Nmpsdm5HYXFRNHFkSnNqaUh3Qmx2MHlodkF4Sm5i?=
 =?utf-8?B?OVc1OU5TV3h6enFKNTFkSXp5RkZvYSs5bGZQTmxUVHFGOFMwZ1U4alphU1JU?=
 =?utf-8?B?dWVISHpCOWNPdjlkeCs1cTZKZ2Ntd21Xc0QzOHVadXZjMHFDOUJzcU14WXdq?=
 =?utf-8?B?SXZKVll5V2F5a0tjak11ZEVjek9reWpKR2VRMXY2ZkFMOHRuaXJZYWhMMmdj?=
 =?utf-8?B?UXF0cUNudG9ERENOczVjM0c3bk1LTVdrTHdicG1PY1MrTXM3ZzFPamJTUC9P?=
 =?utf-8?B?SDZWSDlXYy92Ukc4Ukd6Nm1qM1RPRlcyV3BFdXRhaWIrWCtaQVNNdnRrQnlh?=
 =?utf-8?B?VWxSczVndzg4d050ZmdkemtNdXV1YWU2M2hoZG4vRStNOHBZNmZreUFCeUZh?=
 =?utf-8?B?dDE2aHhWRkRaWGxBOUJyMi9pUVhhenlCSG5xZmdLVVNNam5SRDdiWGNoeE82?=
 =?utf-8?B?VXdFNkoxTmVYbE5PMTBYaWZFSkZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0295772-27f8-442c-1af3-08d9a319e86a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:43:11.9902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GY3NyjCklfBPx0NLlG6jY0+3TymEHaJL4baSyDgVc6TSOA4lwxhgY6Z8dISlsgBJnc40psGOQQOcYjGupejYGsDCJjwd9GN6vSK4fcs4fHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-GUID: o8MDst9-JhB_tcd3WQyku-EzuaRshyOO
X-Proofpoint-ORIG-GUID: o8MDst9-JhB_tcd3WQyku-EzuaRshyOO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> This series is an iteration of Maciej's scalable memslots work.  It
> addresses most, but not all, of my feedback from v5, hence the "5.5"
> moniker.  Specifically, I did not touch the iteration over gfn and hva
> ranges as I would likely do more harm than good, especially in the gfn
> iterator.
> 
> The core functionality of the series is unchanged from v5 (or at least,
> it should be).  Patches "Resolve memslot ID via a hash table" and "Keep
> memslots in tree-based structures" are heavily reworked (the latter in
> particular) to provide better continuity between patches and to avoid
> the swap() logic when working with the "inactive" set of memslots.  But
> again, the changes are intended to be purely cosmetic.
> 
> Paolo, ideally I'd like get to patch 03 (and therefore patch 02) into 5.16.
> The patch technically breaks backwards compatibility with 32-bit KVM, but
> I'm quite confident none of the existing 32-bit architectures can possibly
> work.  RISC-V is the one exception where it's not obvious that creating
> more guest memslot pages than can fit in an unsigned long won't fall on its
> face.  Since RISC-V is new in 5.16, I'd like to get that change in before
> RISC-V can gain any users doing bizarre things.
> 
> s390 folks, please look closely at patch 11, "KVM: s390: Use "new" memslot
> instead of userspace memory region".  There's a subtle/weird functional
> change in there that I can't imagine would negatively affect userspace,
> but the end result is odd nonetheless.
> 
> Claudio, I dropped your R-b from "KVM: Integrate gfn_to_memslot_approx()
> into search_memslots()" because I changed the code enough to break the s390
> build at least once :-)
> 
> Patches 01 and 02 are bug fixes.
> 
> Patch 03 is fix of sorts to require that the total number of pages across
> all memslots fit in an unsigned long.  The existing 32-bit KVM
> architectures don't correctly handle this case, and fixing those issues
> would quite gross and a waste of time.
> 
> Patches 04-18 are cleanups throughout common KVM and all architectures
> to fix some warts in the memslot APIs that allow for a cleaner (IMO)
> of the tree-based memslots code.  They also prep for more improvements
> that are realized in the final patch.
> 
> Patches 19-28 are the core of Maciej's scalable memslots work.
> 
> Patches 29-30 take advantage of the tree-based memslots to avoid creating
> a dummy "new" memslot on the stack, which simplifies the MOVE case and
> aligns it with the other three memslot update cases.

Thanks for the updated series Sean - that's an impressive amount of
cleanups for the existing KVM code.

I've reviewed the non-arch-specific and x86-specific patches till patch 22
(inclusive).
Further patches are more invasive and require a more through review -
will try to do this in coming days.

The arch-specific but non-x86-ones patches look OK to me, too, at the
first glance but here it would be better if maintainers or reviewers
from particular arch gave their acks.

By the way, do you want your patches and my non-invasive patches (patches
below number 23) merged without waiting for the rest of the series to be
fully ready?

This way there is less risk of conflicting changes to KVM being merged
in meantime while we are still discussing the remaining patches.
Or worse - changes that don't conflict but subtly break some assumptions
that the code relies on.

For this reason I am strongly for merging them independently from the
more invasive parts.

Thanks,
Maciej
