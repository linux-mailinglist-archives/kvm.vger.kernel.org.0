Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BB822BAD6
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 02:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgGXAQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 20:16:17 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:5600
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728065AbgGXAQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 20:16:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5H4bU0JHrdvsYO6/mwtdx0jvp9ZedCGUhJDljlLObu0ArtejZj+Yj52q6o9rk3oymsSjXMb15ecskS18sXuOY/Wc+PSTLEkJMbI74WLIeUr2JapkuLzbojjaXVkHPDVtiPNo93LcuIS+jlTC+qLwgWQgpbJCicL8dWVVbThLGLAuwHOcT6EsjYettfNKwNo8Ex1XaFNtGWoPX5ZXkd4ifKuHvX2ts6cNMoXWx4xVUsqDptuFCuI6ppjdHijx3B76S2imWsOj7jSPMx1ADYk5Z2lNsA1AbELfA6kxWCaAl+GDgU7d7tykQ2l5pL5ke6lZpyGPj0aB00MExgJ4do6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+PR5UqQ3rGDrRjplhGOc1b+DhQdOrbdEJMuAg0qOrI=;
 b=PwvLbDZHP6qK5U6oDfchaKagiPLBWBWSCxyc2MA9W/wNjGS9yFqLPzANSzr60RscWrb4vrxq6szWLYnDGOi3KoJi3xMnp7JzwXxpAjw53QSL3PqRTpPbn8qJY3vm6gKa19M1S8ph+sv4VFyriyXhMTBHLj7IZDf/3ez0/D+guYvEpjjv8Qh4wjZSl2N0H5nHICXn0lxKJG8+o5HSbOjemYebCR2TdY5f2vBcxmTAk7paC32WZ1rYVFw5Ks95GhCOJYux2NknyXy109YEF/hWZa0jvxCCWnXSVXxojBdQ4/xJHiH2QZjmqLH4FL6ZhCb5liwl92r47Z7sFZuw/nhPQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+PR5UqQ3rGDrRjplhGOc1b+DhQdOrbdEJMuAg0qOrI=;
 b=lxxpDkojMmiALczhMfZ3eC2wd+QfXdtHuTjcUJThJL/z84id2o+TtwD8Em+FdJTcMwNVQnJklQrisAVCVqNBwJHVTaQo3RLzUmyXnzRt27EyAGbtDZYdTctHhsqhFGUz1kjmJrro6GUEiV8U6prezjx4rB/PhwPVIXFlDVxfHC8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR0502MB3951.eurprd05.prod.outlook.com (2603:10a6:803:17::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 24 Jul
 2020 00:16:12 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.028; Fri, 24 Jul 2020
 00:16:12 +0000
Date:   Thu, 23 Jul 2020 21:16:06 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200724001606.GR2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org>
 <20200722195928.GN2021248@mellanox.com>
 <cfb8191e364e77f352b1483c415a83a5@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb8191e364e77f352b1483c415a83a5@kernel.org>
X-ClientProxiedBy: YTBPR01CA0016.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::29) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by YTBPR01CA0016.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Fri, 24 Jul 2020 00:16:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jylNe-00Eb0e-EY; Thu, 23 Jul 2020 21:16:06 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff3eac2d-469b-4e6e-e4cb-08d82f66c4ec
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3951FAC71A330F1FE38A6E08CF770@VI1PR0502MB3951.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbglQy6WjAPpYzORnQQaSnrvt/ZRToAcv7EDaiKZS3s4imbFLTAVUNMAUloVSM9JneFEz5fS6qLF3cmVU/yB0xOuevmwd/gRUvpbD5+OcufxLtT0jvUUIjsHH+Oesca7BZXXCVrwS2Ux4d+Cv+TQCwXsYMtUW1Iv+yxEgMpB6SMk0LcQZYS+jiBMxVxAR2XbuTOgBbPH6E06Xr0uWSnid/dUeO8uKnE7ICf1atC8jRhbfd3lGiKSfgM+R0Eaj3DVyr5lROsDPpLD8iJrxWZ7c3yNPSSdTFJa8qUDld5hCDFTKtUKXJSAqFHDzXBpB7wflNFNBrMB5LqzVIYDSdmeoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(33656002)(26005)(6916009)(83380400001)(5660300002)(4326008)(36756003)(9746002)(9786002)(1076003)(7406005)(66476007)(186003)(7416002)(478600001)(2906002)(2616005)(426003)(86362001)(8676002)(66946007)(66556008)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pkzJzh3rwgcfpE4ScO4MbqywNt5vXhI9fEv/u0aPI+/4pFIJm0dcn4NDJ/TVlAREUCS5zfHKQbjZocROdeLuuwxnTW1g5AzcI54td018hHrZ/q4rqCOZnLkCHYh+JK4KLoZLceV7S8eH7/Y2uCXFXejsOLwjFUo4Mdl9fZzYK4Su64V2ltODTkY4zPWTPVmUgWRs78dN651J8ueKya/H1PfTnqApMH4sKnencO1OHvzCeBAUM1Fva5ge7mmBOVVi163rtC4eufK/GhY+IKslTDo5Llnudq2aup+Fsn/jYN0mr1rrE56FGHa7Y5A4WEENoimnlpgyQ9bCZ1JPOvWqfE3tgfxmp3irVM8ZEoixDITWsOx2z31b4urCDNjJ5ZBEmT9jGC4ue+5Gh2Y4QsoXiJAbNlCHym4YLrmjYARvNxJNNDMznxamAPIKDSPw70aAg+kkbW2VqD4rKb/4pdZVLX2PN+ujrWkQHCZAZZxE7IQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3eac2d-469b-4e6e-e4cb-08d82f66c4ec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2020 00:16:11.8499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+7rmQRxImwF/MP1RFEgQ6cHT+P0QvQ9Ve3pWRFXBW/esOE41L5SQDb4+ctdQ7XpnBjaRr0DfNs6aJMwvTvang==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3951
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 23, 2020 at 09:51:52AM +0100, Marc Zyngier wrote:

> > IIRC on Intel/AMD at least once a MSI is launched it is not maskable.
> 
> Really? So you can't shut a device with a screaming interrupt,
> for example, should it become otherwise unresponsive?

Well, it used to be like that in the APICv1 days. I suppose modern
interrupt remapping probably changes things.

> > So the model for MSI is always "mask at source". The closest mapping
> > to the Linux IRQ model is to say the end device has a irqchip that
> > encapsulates the ability of the device to generate the MSI in the
> > first place.
> 
> This is an x86'ism, I'm afraid. Systems I deal with can mask any
> interrupt at the interrupt controller level, MSI or not.

Sure. However it feels like a bad practice to leave the source
unmasked and potentially continuing to generate messages if the
intention was to disable the IRQ that was assigned to it - even if the
messages do not result in CPU interrupts they will still consume
system resources.

> > I suppose the motivation to make it explicit is related to vfio using
> > the generic mask/unmask functionality?
> > 
> > Explicit seems better, IMHO.
> 
> If masking at the source is the only way to shut the device up,
> and assuming that the device provides the expected semantics
> (a MSI raised by the device while the interrupt is masked
> isn't lost and gets sent when unmasked), that's fair enough.
> It's just ugly.

It makes sense that the masking should follow the same semantics for
PCI MSI masking.

Jason
