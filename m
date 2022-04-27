Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FF9511F8C
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbiD0PEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbiD0PEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 11:04:52 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2052.outbound.protection.outlook.com [40.107.95.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B531D28F956;
        Wed, 27 Apr 2022 08:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4SCpPuxHUfDswGUUT1FQcmivyyNgRIh9XvCoGCck99esS/qd4cAFzSCn+PtlS9+dwvkDuMUI2JO7E9gqFxoUZtVG2CUxImj9MLaMlGrEQxKBIJhuv76n7uc0to88zQCWEhadMEyn158bNKjMTKGqdNVxxc60rkGAtkt0aOcvPnBXxZRM+Seq5G4BGBflBnzRwrwOXp2WIdF31iJd0jqEbJxG3p8r3dxzcVkMZykd1EJ2Mp+dlg8zKAAwIrfw1Q7xHN/9YvewB+Pls4bzdPAm0Q4l2bJNiET9PURyR4zJs72Bbn5PqFLmU0CkiaZ/nchfqQjXj1w8gAHiqmUqz0fMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWj9drGXcatzOv3mQofl+hSEGNeTNTSI886KsULYRJ4=;
 b=OFASa2JIdGilRUmw13OVXHPLgurAqH4NHn+Syhi4Jul4cRuajkFI81bcdLzR9QluUyh1uKZp4ISJXZD9pncSakByIml3HwgEuqYFijcZxQnNwBkKan+TarHwXUmFwNziq5mn2TlAoha6o9boMPNOKIbs84JQ+TwpsjgWXaabzwxJnLWYCGmrVbA3RLOcLUWiTEql1ckbNVCZ9o9q0kk3Gs80zjLrGakEv2MAJjxuiL8jOTyhnWNiaYsVtjWelvZYGLpNjHUwegzU2XS+Tu7ddgkQaco26ekTuljtQQPhUHQhOTQo0u2gkNPrYvRyQJVD42baq7vSJSR7Vv1om8IItQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWj9drGXcatzOv3mQofl+hSEGNeTNTSI886KsULYRJ4=;
 b=hBgFftSqQ+xPfXFP8JO4uZ+G1clpflgNBpAbSjyIeTHqODuvAODPgThKk4nFWAiYcYVnED3GYMac3Ly4rCg8sort6KhXqeojQWhbskGGn0dRpYkUJn3jj+gorVv1+BgpbrTfMI3edy9s0/FzDFRPWSsP3xrQ4E3PkHVnc4znYUT0ndiv/JUiALRPlU6OVHoWBH3cAJxPgaJLUWwsj2Eoe2iIKhRzW0XbSYmC0WK5uaMSqD+JE705Fk485Ty5jFUB95ealdf9932L8HDrbK9UFkVuRcFlqlTUoB6QYnz6l8kXpflkr0IaDqTsozi0481AeiLELeDGW+rGdTIGyfWZwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6135.namprd12.prod.outlook.com (2603:10b6:8:ac::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Wed, 27 Apr 2022 15:01:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 15:01:39 +0000
Date:   Wed, 27 Apr 2022 12:01:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 16/21] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220427150138.GA2512703@nvidia.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-17-mjrosato@linux.ibm.com>
 <20220427140410.GX2125828@nvidia.com>
 <f6c78792-9cf7-0cde-f760-76166f9b7eb7@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6c78792-9cf7-0cde-f760-76166f9b7eb7@linux.ibm.com>
X-ClientProxiedBy: MN2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:208:236::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73efaabd-bbae-47bf-d8d5-08da285ed507
X-MS-TrafficTypeDiagnostic: DM4PR12MB6135:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6135B26F68A378CEDB201C3EC2FA9@DM4PR12MB6135.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nh5GtmsTFbjwLwM0TFJZ3EnMA380mERb7GxVmGOUTNdsa93AyA3t7mVITjB7MZTu74qlG3ErkFEFjp9FKirErSW64q0DZ1A3hd9CTX+EOu89Fus7NWIVJGeHy9oCKFiiUr/6IvV2cMg6JIn28+9vfORZClmZw5ydy7+zfHYY0uojEjCkhU7l25pky+R93PTGDVV+VcdrcJDowEgh8d9LObF2bzl+3Xjy8jjlu/yKGP5Wb+4d9fAhds7b2GMH3lanyCV68c2GkOWIV+zGhrfby6uIHa2pey7dHItfhHf/ngth+DthqE7u1wQ1x5J7RotUkb7AxxJ/PCTIFen/l8KC5gkZDLFVxn208ISe/jbCzsUzbuQoF4tusE5hxJbgx96bV91fi7Udw47JX3eB4HT76bkXliWitYWlEQg+NPfYWoUc7VA+9t5GTfRnP65/IzosL3MQDTVu69png/OZNPezPaaHSWG/EXFkAEaG6vm3ZvRmLi2O4YyTisxOotZAVMIgvM6adeAHUE5IgaU61n13+tmD7RRuMaWTBWKHM4v0xbVnpXwAarh2Gqo/QmrwlV87kWma31vzi2+5iLb9Vy7cbF9Atu6QbiRddY7fkfHPQ7Q1pz6DZMnvMMemQTuq3IJCqnIBUzH7+Socy0wlnvUsNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(26005)(6506007)(6512007)(2906002)(33656002)(508600001)(53546011)(6486002)(86362001)(2616005)(5660300002)(8936002)(7416002)(186003)(316002)(38100700002)(6916009)(36756003)(66946007)(66556008)(66476007)(8676002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RSZNyvliBmRf9F95iZCtH/YzZMcJbuWlahPZddLEk5qyE1BAReYBmt732Dbg?=
 =?us-ascii?Q?ekOWaxeU8dYTq+1hNcGG8KzEX4ppzlnoy927LCnakt6e60+jkiyWoHRc9L3C?=
 =?us-ascii?Q?XqWz3Zv8LPbmAzQfV6sxOdAIy0pYo34dtIA8idl1uuT/TtYE2bealSD6vmkW?=
 =?us-ascii?Q?8iJbXZsbZZuYfgV3/KMRi4DehfexA/mBK2l6pm1Jr9JueJyd6ZFqke/vMAIB?=
 =?us-ascii?Q?eRDUdU0FRXuj2LZx6qPJj291LHwlWLUtFZcQObdorDN1tNxcU559sEzKwU9w?=
 =?us-ascii?Q?b2/qxDvP2ePh7g/+Z3xG5lj8Z3FvBty0x4phTzuYWwiecgGOUpfNdkG1rRcO?=
 =?us-ascii?Q?fnr6GLz1SQYp5glHu6/vid3b88a/MzvQVY8qVCwoGvDyqjPMIM11BuDe9MpZ?=
 =?us-ascii?Q?Xrpbd+s+aeAFcUBUzwMY64RwUz6q4BXmEwzo2iNUJXK/hrvhGniwLQSQGTZ3?=
 =?us-ascii?Q?Kd3nlYjP3rGmEA8fhcLsv+pk1FgWPxeIF1pRe3YPmkQd6KWswGSPiaq5kRhu?=
 =?us-ascii?Q?wFxg50Ss7FqNIXvbCuP7rmTYgBXnsFjQkR1K1vRH/jC8myiKGB6hl/ljEm8y?=
 =?us-ascii?Q?WGVXNfz3eZYpHBjdWArc73L0uje52oyHuEarN3QFIX+Y8nKGvaNiMUleKsLZ?=
 =?us-ascii?Q?nV47mcSYAEtC06IsoZUcTdyXQ32qkUrCbW0mhHnLyypczYwP58lcYiuki8EK?=
 =?us-ascii?Q?ljFQGZ6QvQ1PyPIFqa1tuPbIkN3BH3QpnraEiXs5+n9iZCAwYlZ2a87nYV7Q?=
 =?us-ascii?Q?FufOMPfe7QUkAaQZPdbSBeRj56FF82LXbI3NyeL7N533EAMh4j99UWZQjGw2?=
 =?us-ascii?Q?GXnPLekiC6DSIBkbgVUnm6h5oFPKxPPww4nnTiudAubzi9FxCgKxjLUGDOlv?=
 =?us-ascii?Q?9ND6HF7S1EdRuKjq9hjH7DiXvQRWvPBdBTUypp1jgXXnFDN091vGNL63v0Ds?=
 =?us-ascii?Q?hEcQ1GaWw06kY2oEqOBu4J4Y89DRB0NyYyWpyLJK1QVGfZoH0OYv+9cXHJOg?=
 =?us-ascii?Q?EU9aM7H2CFwYkrodxQ3K2NCsOPM0EeeDPbmFa7iDZ1MqRlvHJLFVzDO+3evg?=
 =?us-ascii?Q?Hz70+jOPzAz1FMzNrD1BvWConK16O8ou+zCG7BQKHTm4vNVaE6ahE8LCrkVd?=
 =?us-ascii?Q?1hnUEOt7oYo52jF9yYmn3HVeqzXKpNp4OypvHnAfpxunsssI0K6QbC0FvByJ?=
 =?us-ascii?Q?MLJ6UI9/tItHmwBeDL/KvtXJRteApfNK/bZEoSsahtF4nMiXLSrU88Ra9p26?=
 =?us-ascii?Q?DizAKFUC0hn9r/Lo9yiE5h7SC7MpFzKnpzHEzOnyV6Whndb8o0TlR7lIYLgN?=
 =?us-ascii?Q?QZkm3U9xmSF/5cTTT2js1P9eVSahbeZWdEiSOPoKblx5rNRzByhz5TK19zDM?=
 =?us-ascii?Q?5TALQ/Xc2OPvsPvAw0AdBSU2JygEOTWWjJsOQIN2XSGjY/onohtFpnhphAOc?=
 =?us-ascii?Q?woa7/Bk2L63ogwgrY0Jlj3ZGgVP2oCPZ3gf5rqpdtFl4raGsm6cAyKtcqnIZ?=
 =?us-ascii?Q?b54rifAt/KKrdRr+5+roI2fRqSLxC1gQotikWckDEK6PMuZGoWgnAbu+1sti?=
 =?us-ascii?Q?PE4j5R6+U1t9vWUeJg/0V4NfBJGM/4u3FjT8+FbvY/noeGaAnvqXIKs65xNl?=
 =?us-ascii?Q?Hls9aFuu+8OsD0tgvwz8XxDb0nzKa5htC07XtWnkZGVo9G1zImQ1kgeilSSc?=
 =?us-ascii?Q?oUAMCaQd4xeHyZC4sh0w/5YAlCTK6kNCy5VbdWGXRkgwlPkB0tGhgHIYbyoc?=
 =?us-ascii?Q?Tx4fhXgvDg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73efaabd-bbae-47bf-d8d5-08da285ed507
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 15:01:39.4163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLPONy7iws3SHaSZl2AEr+4hyJke4qE50Vg5eRdPH6vJ0Q7ZLYupWr44Prb7Nr12
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6135
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 10:42:07AM -0400, Matthew Rosato wrote:
> On 4/27/22 10:04 AM, Jason Gunthorpe wrote:
> > On Tue, Apr 26, 2022 at 04:08:37PM -0400, Matthew Rosato wrote:
> > 
> > > +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
> > > +					unsigned long action, void *data)
> > > +{
> > > +	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
> > > +	int (*fn)(struct zpci_dev *zdev, struct kvm *kvm);
> > > +	int rc = NOTIFY_OK;
> > > +
> > > +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
> > > +		if (!zdev)
> > > +			return NOTIFY_DONE;
> > > +
> > > +		fn = symbol_get(kvm_s390_pci_register_kvm);
> > > +		if (!fn)
> > > +			return NOTIFY_DONE;
> > > +
> > > +		if (fn(zdev, (struct kvm *)data))
> > > +			rc = NOTIFY_BAD;
> > > +
> > > +		symbol_put(kvm_s390_pci_register_kvm);
> > 
> > Is it possible this function can be in statically linked arch code?
> > 
> > Or, actually, is zPCI useful anyhow without kvm ie can you just have a
> > direct dependency here?
> > 
> 
> zPCI devices (zpci_dev) exist regardless of whether kvm is configured or
> not, and you can e.g. bind the associated PCI device to vfio-pci when KVM is
> not configured (or module not loaded) and get the existing vfio-pci-zdev
> extensions for that device (extra VFIO_DEVICE_INFO response data).  Making a
> direct dependency on KVM would remove that; this was discussed in a prior
> version because this extra info is not used today outside of a KVM usecase
> are not specific to kvm that need vfio-pci-zdev).

I'm a bit confused, what is the drawback of just having a direct
symbol dependency here? It means vfio loads a little extra kernel
module code, but is that really a big worry given almost all vfio
users on s390 will be using it with kvm?

Or is there some technical blocker? (circular dep or something?)

Jason
