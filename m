Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A852F2A8B6A
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 01:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732785AbgKFAce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 19:32:34 -0500
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:39225
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732750AbgKFAce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 19:32:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dt069TIr1N9CEyBmtsc/AxrCaiKykJxIBwyaoSCEhvwIIBqAI3/KvUYbmtUz/eD6icRYMoeTgL6VQ1fLiVixJClDwH6TUqcHBn6kfxR0CsruporZHaBG5QQMCO1IZgtKU7V/duLg9FSGXuPwF8vu3fvBPp/AwNi485rnJDXc2Rgq2KhwtM16c8d9rtjDzwgWYC0esESjVsmhOh0D9qfHrXJ4AIF2fhWOoHPe28H+KdnV8/iU7bhKEllG18PJPzAbPuwPKnQbfdWQ+1oNwDc4zdpwN/htqh3C+hbsLLqkta4rBIkEkqCMemkc/n8h2KOwlc882qIho0suNLrAPQW6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JiSqVs3JLDB5YpdqSeLkN+LcTmHYzs3B5wNudS3Zag=;
 b=MKeq0oEZZTxD/7LrzNeR359hN9Ujg7Pj0I8Lh15aSWHdE7ajU5lbT/F8jush49cDOL9wwIrqin+BRs2+LURdt9UqTiCikaErpZdzruOAoXl4dSu40NvyBo19PEamfWztNdRk5Pc4plpV//9FBFCDA9mO67o93w/D8IkI1qV1oFeJjsAQQql/IkGXLlpFpxt7rzKH2NKILuqUShIfsx3CeNZEJLbayEBiP2S8j+36t8aAy6l3+gPzAH7rHI0f0mKaroiXlpGmyycNlAnJXrwk4ZcNF3OQsq2bl/QKr7AF0fjyzy89Cim4WcEpLbBzOdp8SsUBC0otQHJog24KSbFmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JiSqVs3JLDB5YpdqSeLkN+LcTmHYzs3B5wNudS3Zag=;
 b=dDiVBRPRDQ2548nY0b2F8uZQwVCSpvHP74Zlyz9GTpwFTPWh5o9jnTk/JID+/353M0PEqJT0R5H/G6EMW+Iyx40e42xGhIHOPHstayzMuQPZMQvUAiwm7C6wailL506Y6f0gjn1zJz5TVYvAzfml95ARm1vuyTDwn7K0Fel0Hjw=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3846.namprd12.prod.outlook.com (2603:10b6:610:24::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Fri, 6 Nov
 2020 00:32:31 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f428:769b:3e9:8300]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f428:769b:3e9:8300%5]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 00:32:31 +0000
Date:   Thu, 5 Nov 2020 18:31:53 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Mike Stunes <mstunes@vmware.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Cfir Cohen <cfir@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        virtualization@lists.linux-foundation.org,
        Martin Radev <martin.b.radev@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, hpa@zytor.com,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v7 01/72] KVM: SVM: nested: Don't allocate VMCB
 structures on stack
Message-ID: <20201106003153.wrr7zvjjl3hl2pec@vm0>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-2-joro@8bytes.org>
 <160459347763.31546.3911053208379939674@vm0>
 <20201105163812.GE25636@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105163812.GE25636@zn.tnic>
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SA0PR11CA0120.namprd11.prod.outlook.com
 (2603:10b6:806:d1::35) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.11) by SA0PR11CA0120.namprd11.prod.outlook.com (2603:10b6:806:d1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Fri, 6 Nov 2020 00:32:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4f0726d5-1a96-43f2-de61-08d881eb7265
X-MS-TrafficTypeDiagnostic: CH2PR12MB3846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3846FD2CD465FC310A5218A095ED0@CH2PR12MB3846.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x33sPiT4OakwBfBPOyXrGpbhJs/HxboJUI58YY3sjONWX75pDJKkSnkeDwOnrVFWCoiUsKxq2HonTf5rNJ1PYNQP/fhjIKMwOTtmzAZLFEOO1naAnJNZp0TKoZ4iFMNASocnhHmEeF1jY+V5wcVMoqXODcFJqJ7sMGfDVKp1yTkESWMmG118SlgfgnlVdxXgrQtKbF0GedrbMTNq5fEIOruGM1VqCjwp7eDkfxQ37WNmsCXvIxOLjolxm4HLna19xyIaUUjQT7/yAlVn3xvfXdTnW97VZNBtSAkzzLxGYrOh1Uzuntu423fWVWL612NXO7z+aYv1qAnfhuokLu5RGlFxAK7y8oFu/kCgoGZglDVMOXg9cfilEByjpXoWrG7avwR05Ygul2AGpqnGuRZSIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(45080400002)(83380400001)(6916009)(52116002)(956004)(4326008)(6666004)(8676002)(1076003)(44832011)(54906003)(7416002)(6496006)(16526019)(86362001)(316002)(8936002)(2906002)(5660300002)(478600001)(26005)(6486002)(186003)(66476007)(966005)(33716001)(9686003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jio7brS6/+HVT0ipJ1KGcInDcNSYL8co4iCfNcmMwIKa63iz0toLPdOWPvkYVTo1xxX1Zcbivj0/3NLUdhKdW1lXrHxM6cyl+xMi3QVWtBDAez474whwDXgna0mO57xuluKHNEIRp+i6HcQW+a2zigURi10tdt+Q5crDBJnumH2lMOgY7SrZEnefQYFaA9XO24I38JxL1hMMWAiLGyuNkJr9LXdDsmuoNHnxVaq46GH8OA0LfliCL2xLzIJ7cbSGxN31Sdbc1LS1Pt5NRS9EQGpkQHpY0bYDZcH9kuKlEvJu9lI+JXzBA1NBwi75tEv/02HzIdYwZDh37epvJWSV5GGXZlQtGrZ69VeNRUzrNVRGYoH1CFh7S43jXXRwFk2TbecmI26IN7mlx8ska18vUjAFGvMACnGRqIJ75WGWpoHynKC2mRy3yWgD/SCDGtLjs/EnPJLyCCzM13i3E/gq5fnhsBHIWJz9L+RU9+EFC3BQBwAkLE3TJ89pxjsPtwvmxmu7cBHny7HwfzajlZYksrrHgruSe4i6ltnZjjDlaLuVcHlVcshapMxK6VT54h356H/jHZRfw8BetcT1lkccR8ehUFnUcrc4eSI4g3BMqju3uPZHuZcrQLtjbMs8J8oZ2ESnCy1Luuv6Kd/g5H2dSw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0726d5-1a96-43f2-de61-08d881eb7265
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 00:32:31.2100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RwcDz5SQeqENx2L6mNS+XJRWtq/vY2ideGBYPdCziz7kGdI4hWsDQ8ORr9YIGTPJY3ktDhernic+HvU8gmJtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3846
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 05:38:12PM +0100, Borislav Petkov wrote:
> On Thu, Nov 05, 2020 at 10:24:37AM -0600, Michael Roth wrote:
> > >  out_set_gif:
> > >         svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
> > > -       return 0;
> > > +
> > > +       ret = 0;
> > > +out_free:
> > > +       kfree(save);
> > > +       kfree(ctl);
> > 
> > This change seems to trigger a crash via smm-test.c (and state-test.c) KVM
> > selftest when we call vcpu_load_state->KVM_SET_NESTED_STATE. I think what's
> > happening is we are hitting the 'goto out_set_gif;'
> 
> No out_set_gif upstream anymore after
> 
> d5cd6f340145 ("KVM: nSVM: Avoid freeing uninitialized pointers in svm_set_nested_state()")
> 
> and it looks like you hit the issue this patch is fixing.
> 
> Can you test with the above commit cherrypicked ontop of your what looks
> like 5.9.1-ish tree?
> 
> If that fixes it, we should route this patch to stable.

Hi Boris,

I can confirm that patch fixes the issue. It is indeed a 5.9.1 tree, but
looks like the SEV-ES patches didn't go in until v5.10-rc1 (this tree
had a backport of them), so stable trees shouldn't be affected.

Thanks!

-Mike

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cfdf6f0dd23ed48449e1e08d881a93909%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637401911116171669%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=yvG6Gtb%2FVJnjMTXsOBApU83DCuKx3%2FRAID6f3TpEy7w%3D&amp;reserved=0
