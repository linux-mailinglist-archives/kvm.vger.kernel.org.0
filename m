Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B47C2704E0
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 21:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIRTSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 15:18:22 -0400
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:32616
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbgIRTSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 15:18:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHb5AsZH1xQcsiG/djUjrlyauShlgy/U08Y8w6JlNIdSVlXezP/mmJkAbbfrvvnXLJAGP1ifQYQe98NQIp16PT/maEuQAnvtmK5VZK5VkaOaUlbXDPvpe0uKTji0pVGzrVzT2gGPc4/UsKdcD2Gp85C7EBEj7dBR3ObpQIDsJA8DcLLE7DNaew84q+ZJE37WqsZndXOHMnOeE8A3xVWSGyg4xntx8OgB7o8SDaIT/c8Iw1+rr3ZGTFXDK9qr5txoE/4qwiExTAEKwlq198igimjijPATjxNYAcH7nrSnDVnPfIj06xjI9zduqSm4naWqO6snW3+fNkQCEo7Kg5NxEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5lp7pDnsgSVUjG/t0Jq9TjRpymru1rqVhNI/eTk18U=;
 b=JGotgXbDRg1nWUv47C/Bu5c0zzfMNMdPaGU5MNA2VjHAj9rBnVz/LW8NjFK7PgA0UDxJl74z3qkJOYfHOxeNMtsbFI8evNwHcgHfea3R0c8dtQunw+Y6Fn9XQ4cFxvt8qrhvjwAzvYKTvRJZQOf7NbiKkShBiJyUhzGJvGbdbiJOJR9kNkkmpnl1Wb/ucuB80ZFMO7r9aH2agoBS8zcoIsQSsgJvIunwdKD9y7zn87NwqLOTPelxqJaNTdgaicIcqg8M0APNCRhQIwd9GeffcVKykwuX+bSjAm9YngXO2fSPECBhwk/0NPuYRRup5KOIHlwz7mk5DOZn1i16zX6vKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5lp7pDnsgSVUjG/t0Jq9TjRpymru1rqVhNI/eTk18U=;
 b=AvkhwtwakDFEngjvnwPZ6j4E5Fjl+GFY10iecmcN0cruIEgJn8ut22IvnGRGn7VN7k5/TyppkWaauvl1y+jkmMSEeF4PFFyP/uIpoTQz2sjb0POXUq6xvPZPHqV0S7CG/bwaO3I/GIzo65TKzxeG4y09xfNp+V9XEmToDLz5rRU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.19; Fri, 18 Sep 2020 19:18:19 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.011; Fri, 18 Sep 2020
 19:18:19 +0000
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
 <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com>
 <a825c6db-cf50-9189-ceee-e57b2d64d585@redhat.com>
 <CALMp9eTUT-tsGu0gfVcR8VTcq7aVH87PsegnsbU6TXOoLHkfMA@mail.gmail.com>
 <CALMp9eS+Vgo2O5=ApWEYCrDz80QE0E7OQyLYwrEjErXD2+uZUw@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <79def243-8a3d-19e7-b52f-9d8ded9fb9d2@amd.com>
Date:   Fri, 18 Sep 2020 14:18:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eS+Vgo2O5=ApWEYCrDz80QE0E7OQyLYwrEjErXD2+uZUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0076.namprd05.prod.outlook.com
 (2603:10b6:803:22::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0076.namprd05.prod.outlook.com (2603:10b6:803:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.8 via Frontend Transport; Fri, 18 Sep 2020 19:18:18 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eac7c687-9396-4f9b-aa00-08d85c0799bc
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4297F801AE919F5BEF6CB606EC3F0@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atpgJJ3u8o1bj8PVgVfvjByiNfz7kntSI8ORTfjIHCzw5DsEcCFNQoA2yLvxi4tc4O4RwZFnunIB/oLIqg4FWTbLytlngezZZTHt4z3H1ePVv7JpjqoxfgGXrAT34WFSKv+FpMpa9ZHlXK85JPEd8QmowJdMq5BtpV6SKdaaQaCDAm223bO/SgWouB9Eh65B/Q2vj4PaOS7PgT49M1+wRBA94ORlaSQ7xxHZqJ/4ew9iyYFjl9XiLF1jtoX40g0x5tds2TrsfKT/HZ0Y3H9zxBNUTVKzsDwVSoCTmMtSKKLFt1cMIUEGl+yQWR7+bijAHXO4rt3BP9Q2ehNxAUqPwut69esYEGXzIJ/eZcRzFjlqT9G7UwlOdgqVd+UWHDJhxanBwdjX2ljreQPszO9NLzQAvjZhY3XPUekY3+LIsxRgSMbsNbKoI9f2cIO46Uwj8GDjFPhzcjln3OZBJ/wlv3AScSWFFdzqqql8nPdmn3Ut9zqjYh2y17AtLnYWoMiq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(26005)(66476007)(53546011)(31686004)(2616005)(6506007)(186003)(45080400002)(2906002)(956004)(66556008)(8936002)(5660300002)(36756003)(16526019)(110136005)(66946007)(31696002)(86362001)(6486002)(6512007)(8676002)(316002)(52116002)(54906003)(478600001)(966005)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3mrU07MuOtIFAQC1F8vjs5CwU0ThcpAjx6YKq+46up7G2fAkmFF3fDUUdaknIFZ3lpQwnI4Jra00j0oovUBMSehsw+8OpvOJSYtSyXfA75Ss3nYluSCLhjFUoDWLxEIho2rqHctlZe65cw82BjZD8FWmyZHiB5DRvZ6z3B/40V4PetkdAVQfm/f7woS1qbq6dzxF2TJ7nblJB+0xhc7UIycFBGUbR3J3VUD7Bx3wm1om9L851G0jJgVI/B2SC8Hw6HmhFFFRzx4g4gDwHpfXMmSrRmq4/xsAzCB7md4FgSd2pnsIERkR3jtucvSrQmgasPnBDrMpE76gu68I1swb1Zsg48M+nVXuFBSU/5olsdqJ7MR1XJRKm5cey6D4TnZR01PMpfwtJBkq8ZPCWASZBniy/16VtqnTjzsIr5Ni/GmARrI17e0LujiZZiqA1wGfDwS0e7kP9TuwQ6menqlXe0kV3gKsMbCCjkLS+//sT87xaxOd6ei7Ce8bwMlZWCWoFzx02UFZUhkaRNxu7vp7jVLrZfVcW9/kEtm+vEt+JvnckV2AJqr82GlxsALIpLLnG5vV8/u4v+xT2X1mqKLVJxUpVHW5OlSVaoUUuP1+95c3w3jauMCuX5+o9hFIog6Aygoc+PA3JWDMD1Ue2RJN9Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac7c687-9396-4f9b-aa00-08d85c0799bc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 19:18:18.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i08kX2yaD0PllANctGcWz4cBWug5h0GBRFfIKW4SzOOPqiCf1+B2+SmG8Suc0dm2lvKeFbgTYYok9dx414BSGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 10:13 PM, Jim Mattson wrote:
> On Mon, Sep 14, 2020 at 5:18 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Fri, Sep 11, 2020 at 8:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>
>>> On 31/08/20 23:55, Jim Mattson wrote:
>>>> Moreover, older AMD hardware never sets bits 32 or 33 at all.
>>>
>>> Interesting, I didn't know this.  Is it documented at all?
>>
>> You'll have to find an old version of the APM. For example, see page
>> 56 of https://nam11.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.0x04.net%2Fdoc%2Famd%2F33047.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C9ee685813f444f314d4808d859255108%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637357364669001358&amp;sdata=3a%2F0OrkZHC7r8vsoq2yhKqt8cQ8siPt6PG%2Be674yiXs%3D&amp;reserved=0 (this was back when SVM
>> was a separate document).
> 
> Ah ha. It looks like bits 32 and 33 weren't there in version 3.14 of
> the APM volume 2 in September 2007. (See
> https://nam11.safelinks.protection.outlook.com/?url=http%3A%2F%2Fapplication-notes.digchip.com%2F019%2F19-44680.pdf&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C9ee685813f444f314d4808d859255108%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637357364669001358&amp;sdata=iZ0lotbZ4kRtRrjE9bVb%2F9NSy7H3RMJauUfe3FvGDT0%3D&amp;reserved=0, pages 410-411.)
> They had appeared by version 3.17 in June 2010. Maybe someone from AMD
> can enlighten us. My memory's just not that good.

I tried to do some digging on it. It looks like the support was available 
back in fam14h. Not sure about families before that. It would have been 
nice to have a CPUID bit for this.

Thanks,
Tom

> 
