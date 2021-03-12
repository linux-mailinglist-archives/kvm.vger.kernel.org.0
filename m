Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF93392D2
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhCLQMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:12:34 -0500
Received: from mail-bn8nam12on2088.outbound.protection.outlook.com ([40.107.237.88]:19968
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232248AbhCLQMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:12:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eM1aPdszA/wlpiJ3hGijp+8aXXWqffpY1ZsKaDV0kMlLBupjBmiiMyJt6V8SOdPaqZeOlYyq3sXkzSo2/n65jw7Cy1DiW6Te9DCWgfJP8sZNZS5EWXXntPoshpe8atS4/NR5AdrPKEE4MecybGXRRhtQiZQ5ZBwOleAsezC6KfEINirKvEFDhxGlHaUuEZlsF/QZPNgTcQrkcmeKhP4kfjjiRhnxzN00hWV1zW+srhmPSRVxuxCKrxlUQEG3SU9gS9FXEvD8TC6YyfQjM+kDLnpwsJJxCEYWM+Dx1pfklf/0O1Iy10udCcB0YOo7XQCrIdTqHCzANftbp2ewNDq6bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNIQHTuwCaTFO0HipbyO2niL6Q0ajMZvKYMvIsdMZUw=;
 b=Ru5iGOMs6q8Ai55xaaF/czq7XjjHRHg2/wi4woy0GmC53OPe/kgynMNCwztagDuKMvVYNV3ObYbG2pGizGaEHc92xUIpI7W98y6tLyDSatWpyqXUFidlNnpQ1U5cCcexEy0T0bZyn4/K73OdBDLIpufKzy4W2abf+J1JqZKm4NzIviOf21ldh4SesT4JV2ArZ2xCf73adrFwv7BmjVRq4aAnhvQ7SjM+qbgtMgj5xJ6tCaiuC8Q7oTXJj1aogl8WXdJaPQGiTvm9HjtglWFDyiFwWqK/WDffh2QObi7ocatrF2FvAuQk+xpG/mG4srygXynfQa9P9ssCzjC+EwzNkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNIQHTuwCaTFO0HipbyO2niL6Q0ajMZvKYMvIsdMZUw=;
 b=J7wnYB17kuTwSQbTio19EP6C6V2KQZnCMVlCSa0cWupd/69ab3L2+f0bo82Tr/IXXlus3RlpX3VtZwThn1kuKyAe91/kKFC0sRSTNrPXJ8IQ5tCXuLguy5k2f6cFenFlwpHRfKfAAC0WzId2IvgpeTFdhUOH2VvEvz4ys3c3DtA=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2623.namprd12.prod.outlook.com (2603:10b6:805:6f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Fri, 12 Mar
 2021 16:12:24 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 16:12:24 +0000
Subject: RE: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic>
 <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
Date:   Fri, 12 Mar 2021 10:12:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210311235215.GI5829@zn.tnic>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0801CA0019.namprd08.prod.outlook.com
 (2603:10b6:803:29::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0801CA0019.namprd08.prod.outlook.com (2603:10b6:803:29::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 16:12:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f522e3e-0824-4a64-d4fa-08d8e5719f41
X-MS-TrafficTypeDiagnostic: SN6PR12MB2623:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2623836CBC4F4E3264183C2A956F9@SN6PR12MB2623.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwVA6Dlf1uEqK4RcM7FvPq7bHXV4NmLVS//OOT4rcOKY5+YWQbErSw8frySNry/L3yUInCxwQXlt01ZXB97L10RoFtctkLTVT4O78r1xwqJjdeYjdifyEAMzMU4VRw1xxHljXquamjtJbeAnIpjUVWPBqpb+mnypChNMwkMD/SCYYFJXvu77TJirff0Lx3YbLHMxQjOkixnVf42+Yhb4qpq05oDZDcSs1ynkTQiyCYiZRhR7TL+D+8IFsJkGbFGLlfKoePzL5YvUwL6JrRwKETMXGLzF/DNdXAQfjNg+ddZOUSsz4+w1gHOCCH0zZjqkxkUkOlA71W4ytLv2Jgspd3gNzCrRE0WYucShMT9F3uopCkzGk7VQida7XgIsPMLq99X14S/yu85AIKG++dvHuBLnsokqbN8+dwjAZsZ1kH9UnEZ4L+qufeXi3mxTlrx3J8aJgEwwhckyGyyyhOpHplYYBk9vdLyNnsBXXzBLPt+luCWs/Y7MIYfoKHrAFKNjpPeH+KLLxJ+oI5skWdGzeN6UyqREqOClyS/wOGGMEfFMpp75pknzzX1/NFpjwHO2o0vOpdIApl889HPpRRZ8RsbN08Xyudi4jsKVKN6pbM/hW+aUzFPBCarBkXAsL3pMe36xw5ByPdjzuUdSDkfP3WD0YNvEmY54o3gIwcVmCZ8EcNfPL1I1y/Vc9u3dl24hobLJD6eTmm2vfC8oU0Kldg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39850400004)(366004)(8936002)(478600001)(6486002)(966005)(54906003)(5660300002)(86362001)(53546011)(16526019)(83380400001)(8676002)(186003)(44832011)(31696002)(316002)(66476007)(31686004)(66946007)(7416002)(2616005)(66556008)(2906002)(4326008)(6916009)(36756003)(16576012)(26005)(956004)(52116002)(10126625002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?8mr7eLxna6lrCWO88od8zAjOwgU4sabmlVGXsnHC+DrZpYoXVHpRpAVf?=
 =?Windows-1252?Q?CLtw9ZikwvUcRhJ51KaDZljLPcifncJckJQsHtHGePvRmXUvIVySMefx?=
 =?Windows-1252?Q?8EiVOt5Zrhiuv3os8yGbJNZPx5bgHUfocMk+7jy2NKGwy+RajI3wyIf7?=
 =?Windows-1252?Q?VV5YJL5prCXD+Kf+66ZIJUNkHe7rF6x+c0q/olI4YUgpLdCEyHAxAayw?=
 =?Windows-1252?Q?UWztplzKDaakOPrqR1ahk6RIdsbVJVPg+BSYk1acNQtqrcudeO7FzhpW?=
 =?Windows-1252?Q?rUIqnWVAbbaGr5xpLVOLx5ZpYaZ8zCls3v5lBqlavFNNKUlvpmZz3gYd?=
 =?Windows-1252?Q?4t5B7pn5Tzjk9vZyXoX/aE90IvnBD143249Z0UpybQtiSeuDBY/n3n8V?=
 =?Windows-1252?Q?37oTM6V7zzGEZHG80O/DhoUT9WsTXf5XeIazqmdfZ/NYoOVfztw4kuqX?=
 =?Windows-1252?Q?423F1MSl0DV3Iadt+lFup+9CNxa/GqQEvU4Nae3CbM+xTMvqtuxWutYn?=
 =?Windows-1252?Q?rdHhtJzDorRxMK1PnJm1F3nH3qlrMqkr0ny2LDbiEi5huFxdDCNRj4bX?=
 =?Windows-1252?Q?q7kevKpMtvWTw4RzeHQCEZFYba4MiUJWDpPzNenfn1w+GDnj5+RAjVB2?=
 =?Windows-1252?Q?h2cxpHnAC994EVyuzZaiXwb8TmGqNqfIjAI4ciSixmnKX9lyIra8VZaY?=
 =?Windows-1252?Q?GW9Ag5QbTsshva5RnXFhDSFWyAELHhMBrAEujK+Sjs6t9uI772ICArh5?=
 =?Windows-1252?Q?iCZjyNK1lops4/av1QO6iXAlrWijt2Qgv8jnF5R0JgWnhuFieAPxaOT3?=
 =?Windows-1252?Q?bCo/+qSF8dJuJeBQB9KTJVNagYLFCo6XCkQKEXQYmO62wthvnVftWznz?=
 =?Windows-1252?Q?OuDwVB1qQ61rQgC/3UbwIkpnSRAuDv1o4NYF9ecd02pjzll8KS879csI?=
 =?Windows-1252?Q?MmOJJR/SMfHDgxK4ZSQMyXrE3vR30l+ACcMjHTKHOWb7uF010vT6N1eA?=
 =?Windows-1252?Q?6Aw7IkWryW3XVgv9AE/wx6ODjSF5ud4Yt5kcTEKvSmoRixkvF8xetcu+?=
 =?Windows-1252?Q?pxf1VLDmU4iRwFgCRUKCOUkrk3CllrMKJ2hdcO/KR57CRf6JGOaedtM2?=
 =?Windows-1252?Q?A91NrgJaYmvj2JwIeISMYitvd1Uzss0xCepT0hJr1VoFylRVD8lqFLjj?=
 =?Windows-1252?Q?q5g+2Kis/9t0JbwyWQbrTWohi90mbq/bVmqJ5a0ELg9BXrrHKgwFNd6g?=
 =?Windows-1252?Q?eV69NwPWL073zNNpqOnpDvunsJmvIyMrF1JIQrOBQZ1SZUtds2Qe1xzX?=
 =?Windows-1252?Q?emza9TCCa3cXLXw3B0Zq/w792pYTzDeGCXHvD/lOmc2WaIjooBFR5gug?=
 =?Windows-1252?Q?bzuC3VTXgCFOEfhBpwC44ezsEQ+1I1ulHYXLvEMclm7cj/t9T2S3dksB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f522e3e-0824-4a64-d4fa-08d8e5719f41
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:12:24.0601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8uFM2CEwKEyr9Nw8R5kT+YS5gKorE7LaK/7R1osCVNd183EGYjz/tdLLrhGFeEM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2623
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Borislav Petkov <bp@alien8.de>
> Sent: Thursday, March 11, 2021 5:52 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Jim Mattson
> <jmattson@google.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng
> Li <wanpengli@tencent.com>; kvm list <kvm@vger.kernel.org>; Joerg Roedel
> <joro@8bytes.org>; the arch/x86 maintainers <x86@kernel.org>; LKML <linux-
> kernel@vger.kernel.org>; Ingo Molnar <mingo@redhat.com>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>; Makarand Sonare
> <makarandsonare@google.com>; Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
> 
> On Thu, Mar 11, 2021 at 04:15:37PM -0600, Babu Moger wrote:
> > My host is
> > # cat /etc/redhat-release
> > Red Hat Enterprise Linux release 8.3 (Ootpa) # uname -r 5.12.0-rc2+
> 
> Please upload host and guest .config.

Host config.

https://pastebin.com/wuLzEqZr

Guest config

https://pastebin.com/mvzEEq6R
