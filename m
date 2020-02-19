Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF783164338
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 12:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgBSLUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 06:20:31 -0500
Received: from mail-eopbgr60121.outbound.protection.outlook.com ([40.107.6.121]:51978
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbgBSLUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 06:20:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUUp52KxfSK4kJHsaeRgyFIwebhVKEzNY3MNJ3NzvaawOnHSGqWtN7lJ5gnlPlUVTa0k327EIFS236k6HC5Ron0ClNcCX0B/i2v+rLNuxFmQ/mZPjuZBsS/5nHcfQ9oFCNcXlNwGSKjVNZzNNQ8hQB6UD+fILPER3wLc/k6JgPqkBKC5tCGIrR4bKXwQH17ic+RhMj7Hes3O/lPdt7J7stUqPZ7/Fuh2NFKIwe2/bLMjqYD0/H1O83vByixhGWEWZ+K0nqBRYUJUUo4oWW/eeGLsPASe5TayA3uq9KAqmWY5O8EcpWNyzlQrR1RqdvA/scgDrFLR7uleZRl+gGAjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRqHHu/PwHfTszKwYrk3C9YVOSR4sMfgAqyS5YRtsYg=;
 b=bSA0jBif9tCzfTfoFFJgupWGJTEd8dOOd+J860Qetb+XQPZT1KAY5cKi5Q5/e0mE0fKTtUocMSri8yDFvwzTUloSZU/VrEdHwQavZqJguorItM0rFZWgla2OXDAYVyeRhJhlf7hJ/+XT7BmkA1ely2VcZFp9JL+z7YHRujnvXBDk7iKmP/QjEtmn7uErOTufDqJo/WC3doeXwu9+fcD7HFhaHD0HkyO4/FzMMH4MSfRySIm/EuXBnfCOVwL9wja4L+17d+KEmmEiwELaGekexEpA/u6YUqpwqXV3dYdhTTTvA8VzHpuEJi7Qttt6S8tu5cBxds/EdoP929h4742UMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRqHHu/PwHfTszKwYrk3C9YVOSR4sMfgAqyS5YRtsYg=;
 b=ipVAdUY6jefmr1B2Rd0GKwTCiYfdP2GmMRBbgtwdcgheGVrQCbzVmohU4OMxi3TnqZX+oyH6+RWxN84o59nk6gWVtdNCJ9UfStEzYUaA+q2y+nFZYZbr7GdHhv5GqKJR6Yr+pbTjafQ1xxagGHU8DsmLGOc58IU/ViB1reKCVzo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=e.velu@criteo.com; 
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com (20.177.48.80) by
 VI1PR04MB4112.eurprd04.prod.outlook.com (52.133.14.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 19 Feb 2020 11:20:27 +0000
Received: from VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4]) by VI1PR04MB4926.eurprd04.prod.outlook.com
 ([fe80::99f4:5892:158f:5ae4%5]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 11:20:27 +0000
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Erwan Velu <erwanaliasr1@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200214170508.GB20690@linux.intel.com>
 <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
 <20200218184802.GC28156@linux.intel.com>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <91db305a-1d81-61a6-125b-3094e75b4b3e@criteo.com>
Date:   Wed, 19 Feb 2020 12:19:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20200218184802.GC28156@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: LNXP265CA0069.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::33) To VI1PR04MB4926.eurprd04.prod.outlook.com
 (2603:10a6:803:51::16)
MIME-Version: 1.0
Received: from [192.168.4.193] (91.199.242.236) by LNXP265CA0069.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5d::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 19 Feb 2020 11:20:26 +0000
X-Originating-IP: [91.199.242.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abba21ef-3c38-4858-0607-08d7b52db867
X-MS-TrafficTypeDiagnostic: VI1PR04MB4112:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4112623275E239C0F36EF79CF2100@VI1PR04MB4112.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(53546011)(4326008)(5660300002)(86362001)(31696002)(66476007)(36756003)(54906003)(316002)(956004)(66556008)(2906002)(16576012)(66946007)(478600001)(2616005)(81166006)(31686004)(7416002)(81156014)(186003)(16526019)(8676002)(52116002)(26005)(8936002)(6666004)(6486002)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR04MB4112;H:VI1PR04MB4926.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f5H7+0/gn7OYIfKTJ3PQyIe0SgvtoE3t+1FC/3QEsVuHgnsYudpcGS6C3/XcZR2REUAnvLqXCes7LNO4omDJqEikBpucg6lnPUrClrQmaqU33S0OeDKNgoUwox05FMxrBf/1IqNvibu5qjXZVJBwXsn6I+EyBip514IvHaRSLyz5z2zGSI6OHGZDDKnrvW0wAxWpdUkOK+v+SA3+rqnVK+v4qSSGYBgxb6TQbLBEm5+4QN8Khzwz02HWo6zf2CcIbNYrg4G8fI+RgG5OKdGSeRX0CnSko95BZJFBDs7xWUioUnYE5cEtkYd8n8WOmaXqfSpJKMqZnxI7+JCWs4w3Trlueygi/bmahTGMNfI1Vh0ZmfgXR8PnpWKHVfEoWMQbJd+vDnoZSzfR/N2r2bDw64nfMOZDpAkhUqXlE4YVeF0gP4YRw4TyOXISx8MmErlI
X-MS-Exchange-AntiSpam-MessageData: SIBKJv/EiQnkF6oqLYgfzFlyIOeNrKo8c8NqfTbulQWRk2wjyLINEGxWRQnZG6L3ta2HVuiwK0xHdwE5bEkTCAMzi0Nfa8r0hLSl5TBC3z6t7yCEF0MfIPJCe5KPZIaUp6G1MB+copy91Ip076p/Hw==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abba21ef-3c38-4858-0607-08d7b52db867
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 11:20:27.0728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: temZXt3YHMuxhuec/Aa2voDcpkwSBNWzSdjS7R4zC95/uzV9WrE6gyWWSOwAiuBysJirOqsLk6FYjt21mjPK/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/2020 19:48, Sean Christopherson wrote:
[...]
> Fix userspace to only do the "add" on one CPU.
>
> Changing kvm_arch_init() to use pr_err_once() for the disabled_by_bios()
> case "works", but it's effectively a hack to workaround a flawed userspace.

I'll see with the user space tool to sort this out.

I'm also considering how "wrong" is what they do: udevadm trigger is 
generating 3500  "uevent add" on my system and I only noticed kvm to 
print this noisy message.

So as the print once isn't that "wrong" neither, this simple patch would 
avoid polluting the kernel logs.


So my proposal would be

- have this simple patch on the kernel side to avoid having userspace 
apps polluting logs

- contacting the udev people to see the rational & fix it too : I'll do that


As you said, once probed, there is no need reprinting the same message 
again as the situation cannot have changed.

As we are on the preliminary return code path (to make a EOPNOTSUPP), I 
would vote for protecting the print against multiple calls/prints.

The kernel patch isn't impacting anyone (in a regular case) and just 
avoid pollution.


Would you agree on that ?

Erwan,

