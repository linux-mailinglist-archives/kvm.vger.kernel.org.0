Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB53B3166
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 16:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhFXOem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 10:34:42 -0400
Received: from mail-dm6nam11on2040.outbound.protection.outlook.com ([40.107.223.40]:55859
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230377AbhFXOel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 10:34:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAWCyknkKlGxDl3ieP7iT5OoiaeF84aO/SaZQ8fsm0if9wx0Y8QSlzZpIJ0JPaITVocbpB/1SVEpUZggY3V8zq3hGULsgPRNfhL34wBofhGc4dhF88efG+NK9jNwJ94oYPTc+/FQrBQ2r+iSpPHU9935+CqfiyEvqFXZUPSZg14ypNGrsUZH/OuU4P5M1AhyhIhvXbCqhc9THDq1y8wbTCPt1LF0nTpCLaTwGqVSHcNxrgzG7gxUd8FaGibL6KPYxgd9kWI3/e3uGcP41/OyQAb9Mzj91ZKlOntc/Lx5TPSaUVsMJRlOlQjBAB+lXHnqq0bOjznDdFDUNnTakeK1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OH2kFlPJChRn00svStolZEPApJXXOMw4FqMQ/3Z9SDE=;
 b=HgtUSMUL3Y/tYzkGRSxmuhjfJP7iNMph7klvQospcZ2iimlOK5s1OY9pYfbhWkXNGWDhpfg/3HmG07W2JtV7RbrwN6ozqPYJdn7hBq7o0ILHMbg91Iz2qh0ym5FAs0XR7Tj3qGM8H4yNwokY/9j2zUIajFwyRBtkcMHcqYsoeWrPjmJ+TL0CoZ/3tRprU3AeSmUNMaRAfaDgs3NyTjUqPWoekv5yHyxcEZ2f1mDRQlDuDKuDvOS/HGGU6laAMal7g651Fh8UY5w/PAeGGoDPszabP8UW0finwV1BMOU9UfOld8hJfAHD0GJ5QOpJ3tjCbSRZtxbftkseWXuOO91nzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OH2kFlPJChRn00svStolZEPApJXXOMw4FqMQ/3Z9SDE=;
 b=dIv09jZZNMf+OKAT4VbnjJczFwC44Pz5H0Etj7jFnQZF8QITUb9Mq4YVHeJBYDNdUVAo3qBjthQzrgD0ZKlp/951E+jO7M1GZoSlCNmPYgsb+NyOhDNQux7pEzKqQO007NvltzVAO0TaUJ4Cqc74os8heewBb8wDRYrCKrg7gkY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2891.namprd12.prod.outlook.com (2603:10b6:5:188::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.29; Thu, 24 Jun 2021 14:32:20 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::6437:2e87:f7dc:a686%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 14:32:20 +0000
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
 <ac98150acd77f4c09167bc1bb1c552db68925cf2.camel@redhat.com>
 <87pmwc4sh4.fsf@vitty.brq.redhat.com>
 <5fc502b70a89e18034716166abc65caec192c19b.camel@redhat.com>
 <YNNc9lKIzM6wlDNf@google.com> <YNNfnLsc+3qMsdlN@google.com>
 <82327cd1-92ca-9f6b-3af0-8215e9d21eae@redhat.com>
 <83affeedb9a3d091bece8f5fdd5373342298dcd3.camel@redhat.com>
 <a8945898-9fcb-19f1-1ba1-c9be55e04580@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6fc7213f-9836-0245-39bb-a05554c85680@amd.com>
Date:   Thu, 24 Jun 2021 09:32:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <a8945898-9fcb-19f1-1ba1-c9be55e04580@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0074.namprd04.prod.outlook.com
 (2603:10b6:806:121::19) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7PR04CA0074.namprd04.prod.outlook.com (2603:10b6:806:121::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 14:32:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86622d28-7464-40d5-5576-08d9371cdfed
X-MS-TrafficTypeDiagnostic: DM6PR12MB2891:
X-Microsoft-Antispam-PRVS: <DM6PR12MB28915B3B6E37401797E44A01EC079@DM6PR12MB2891.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+vyXoQErE4yhUGa9GbnHQTS1wudZARa3L5oX2OGW+RcNuk4c4OAqPCTcwhGAKpBBZ/Ph6fcE/zvtW6j9LApsrNy7ezGKjjAgPRFxnkKxR4RzI1I3HcGbseqRzcnGfgV3aDYz+kq53VhVy5jPDEO6s6g1WCvMro1lRWI0GUCbWGl9RXu0miYV/H6MGJ/MicKZkA1969/5Wbosj49j/92A3yyyqGa5WwkFBbOVVhFRjU9e18+jqECK9XgioOmGpJ8M9pvqPa/Ue8GqXIUzR0C52ayxJNateG5Wpb2zyxOSN7f56Kj4Y021s8I1y7eXTqsJc7r8+dhMoA9DmnUQjMK1Y9DTrgJ+UBl6o8NcFkV6ChSQSSIRZOW3ZGDD+Z2wkpqCnS+wnlrLJ1oIF1rRHMXaDeOkId6y8PX6ZGQRZEDs+7XcUcXOGOn8hJeB8h/l2W0QJ4eevySF/DS2ZTbfEkuf+sCKfPs6tV862Rw8CF/H/z+zqephAGylVp9nt3JScZNMcQbDcBAq1xNyQTtvEg6xgmBExhrqkX46dghP/cfmN6KK1xIGdjdSD/jLKytas/Ns3/9lDxsvXUs1qZjPl/f6XGNuyPyuKBigPARGj8f0sHFnRpHCFG1xM/VWceVypz+CHX6yFcSG6modKQPXffaf9gy1IW7qmeQ8XbiG2pKNYHBvJ4wTsIeSkmZ0KiAwWf/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39850400004)(36756003)(2616005)(2906002)(16526019)(66476007)(956004)(53546011)(38100700002)(54906003)(8936002)(31696002)(186003)(83380400001)(110136005)(5660300002)(6512007)(4326008)(478600001)(6506007)(7416002)(86362001)(66556008)(26005)(8676002)(66946007)(6486002)(31686004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGFrN1ZrWWU1SC9UREdoMHlDUlNiZ3BQRktnemR5N2ZCeVNmTVhMQ1lJV0cz?=
 =?utf-8?B?a2s2cHcxUnU5N0RGbVJXU0lUVjYwbWJYcWp6K3RhOW9BenZlbTY1U0lDSUpW?=
 =?utf-8?B?ekNJK2hnMzJDZHkzVUhHMDUvL3ZtMzBSZXExL0xvQk1ZejVFSXAxcWxFbHNy?=
 =?utf-8?B?YkgxdHIwQ21SQmpYdXRkWWYySlRpMVVhdFVaRzZEeFBLZDQwc0VmUTJyQVgx?=
 =?utf-8?B?ZTB5ajFnSGc0TUgzOGhZa2JSdGxmbE9wcTREeFV1MVZIVFNQOFUvaHRnZW1I?=
 =?utf-8?B?L3VUL01YSFU3clZlbWU1ZTFFdmNMbzBqenBRUTJabWVkbGp1MHB6M0RVNnc0?=
 =?utf-8?B?ei9HZFloWXVNSzNsNzc3MmtYWllSK1hURU1YMjlpU3dTS2xvYmtGcE9uNHRr?=
 =?utf-8?B?RDhjRUFHQ3B3T0V4Qmw3cU5FUjlFVE1GeHpjTHZmVlZXbkVwRWY0V2xQVFNF?=
 =?utf-8?B?RlNqZWNWSzlOK05JVXR4SXYzbmg3TTRPUW1iYzNoMFNlNFc0SVRUZGZqclh1?=
 =?utf-8?B?dDBsaVdyUFduelIyUlZJWUxQekZhRWZERDg0OTYyVUd1OThGNE10S0ZjRjUr?=
 =?utf-8?B?QnN4cVFNb3dWTTU2UndORCtVb0JENFB3WWJ3U0VqMG50UktCRDVoTXhoRlhT?=
 =?utf-8?B?YVlFRktCZVZUMmJPbWxONXp5c2JBd1lhSHdJNFN5S1BTUVV4eGgzaFJDSGJ5?=
 =?utf-8?B?amFzM1B5OWswT3JUNjhNeXNBd3R5NTRKb2RFOUtXcE5EbFREaXJQZ0xDMi91?=
 =?utf-8?B?UGRaK3FncGdUMFR1c2J4TzNETko0TkI4b1pINmw3NkYwY3FUbEFXUlZMVmd6?=
 =?utf-8?B?aWE5Qk9NRmlVWFBvOXIyWnRhRGxsVFoxQ3dJNDBscHY1U2tOZE5yT1c2anl0?=
 =?utf-8?B?RGN0dXhlU3V6M3VJM0h2TmlGR0lNcGZZN3Q3VU9ET1MyRmFybVU4MkRBcTZ0?=
 =?utf-8?B?dllndm5RR1V4UFV4WllMemJjQmNhZ0Fjd0hDaS9tbXphWXlTcThqVGR1Z0l6?=
 =?utf-8?B?RHp5NlZkWHkxTHBiaU8vbXh1NjRJN2pLdnh4eEN2aC85VEtPeXFWWEkrbm15?=
 =?utf-8?B?dGwvWU5SUzcyRUw1OHl2dnVDR0tnL1g2c2hwbnp1bG96UWNBcURyUlpmSkM3?=
 =?utf-8?B?MDRkTENhaFVOSXpWY2tseDBKRy9qVzRjekd1RjZQZWUvZlhOa2d2ekVNUGVB?=
 =?utf-8?B?bWVmNU5qeHhWNzFtdGlDakk2WFd0ZDRNUjBHc0kxS1JlZFZkNkxzRTFnaWRC?=
 =?utf-8?B?Y2NxY00rQi8wR0NEM0lTL0d3a3Z3ZFRYQThqWm9wdTN6MjRjdWcyMW8xbEFP?=
 =?utf-8?B?d3NuSnA5WHRCOFpBSXRNRE9rRURFcVhCSCtKM2RmL3B6MEZZSTM0UllBWEx6?=
 =?utf-8?B?Njd1RlpqSkpRcGM3N0sxTXFEN1lnSTdCME1kSmpJK0ljTGZhVzhramdtMEgv?=
 =?utf-8?B?ZXVjWFIzc1huOGJYZ3pWTVlnejlRWkk0RTc0TzlvZ2VZcXM3YURjc0lyLzNC?=
 =?utf-8?B?SDFCeHcwVzY5VTRhNzdEdWJ5T2NCcDlKMXl6S0lJdFdER0Fud0ZNS1hUbEhi?=
 =?utf-8?B?UXkxRlczMFJpaDc5QUhoMVdEWjA4ZVlzM3pYTTFxR1E5WmZMMlpRUjc5eVhY?=
 =?utf-8?B?b1o1M1NjbTJMZ1ZWbDRBcWtJZGY2RjEwR0pYN2RhU25XLzVUS3pseUloclRS?=
 =?utf-8?B?L0NNUGhHWHk2MGZseVV2dmJhVHg3Sm5EMVR1NFBLazk2QzdDSmVQTDZNNTd2?=
 =?utf-8?Q?vWzbOHiDFg1/JGnvK0NOnMYgmwNJ+zUY+y/X+fa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86622d28-7464-40d5-5576-08d9371cdfed
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 14:32:20.7199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQ8wxYxlcPQOHMN8Nmef4JyVBkRyNr/WQRLJEZV6xQFJZzeWORNepGxh+d7iimmqDpiWltugD8g5zxFe3fFfHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2891
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 5:38 AM, Paolo Bonzini wrote:
> On 24/06/21 10:20, Maxim Levitsky wrote:
>> Something else to note, just for our information is that KVM
>> these days does vmsave/vmload to VM_HSAVE_PA to store/restore
>> the additional host state, something that is frowned upon in the spec,
>> but there is some justification of doing this in the commit message,
>> citing an old spec which allowed this.
> 
> True that.  And there is no mention in the specification for VMRUN that
> the host state-save area is a subset of the VMCB format (i.e., that it
> uses VMCB offsets for whatever subset of the state it saves in the VMCB),
> so the spec reference in the commit message is incorrect.  It would be
> nice if the spec guaranteed that.  Michael, Tom?

So that is (now) stated in APM volume 2, Appendix B in the paragraph after
Table B-3, where it starts "The format of the host save area is identical
to the guest save area described in the table below, except that ..."

Thanks,
Tom

> 
> In fact, Vitaly's patch *will* overwrite the vmsave/vmload parts of
> VM_HSAVE_PA, and it will store the L2 values rather than the L1 values,
> because KVM always does its vmload/vmrun/vmsave sequence using
> vmload(vmcs01) and vmsave(vmcs01)!  So that has to be changed to use code
> similar to svm_set_nested_state (which can be moved to a separate function
> and reused):
> 
>         dest->es = src->es;
>         dest->cs = src->cs;
>         dest->ss = src->ss;
>         dest->ds = src->ds;
>         dest->gdtr = src->gdtr;
>         dest->idtr = src->idtr;
>         dest->rflags = src->rflags | X86_EFLAGS_FIXED;
>         dest->efer = src->efer;
>         dest->cr0 = src->cr0;
>         dest->cr3 = src->cr3;
>         dest->cr4 = src->cr4;
>         dest->rax = src->rax;
>         dest->rsp = src->rsp;
>         dest->rip = src->rip;
>         dest->cpl = 0;
> 
> 
> Paolo
> 
