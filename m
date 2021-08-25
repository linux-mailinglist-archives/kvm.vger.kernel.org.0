Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4B3F7E76
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhHYWZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:25:34 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:44425
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232607AbhHYWZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:25:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hP+hZehhiZ6uZKhe2zjtj/kk9/EMvi1+/VOeh1L47jr/Zzhb4XhszItxfrCJ5RrV0IJwFYDBhicws9z/tKsxlLr3+MUAMoEJOBVTkDJ3Dj7ifX/lzGCEqFjxTlaH/IFHfEbTGZ1xB2h0yjOM3Eh1Rvyi2ZXpyuiCYlC+9lv3w1kbN2fKQua8ysWda7JXQzthtWDrgN472vJfM0R5/jfTYdinTBYm3iA6NTrqyI6Yx2deF3YwhM7OEhC/1a9T6wowq4pZwzHJ5hrl4LiU60uY4cJ+Owmg7y/jUzQLAxIFoIzxL2ShSXSeudAaau75aGCExQI0yPyiVX4mCzqL1JcQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l72TPJSrgoZMg3rvSAAEwz2h/E/CK9mZdYGcSSYVkQ=;
 b=LSJqZCVxP3bKEFWCQL/hWHc57xIO3625wG7kNGhc7qT6YPutqR6AF+TPf3hPO3TajRBCghEDhJvBZe6AFg3nY/VmOruiL6gahRc6woQ8bysvB6Id4J36zhQzEH/LEuGWnQCOfsDorKYa9I5+T1jR7uv1vs37UfP32roXqsR7i2S5gae3wq80uOTfolUJEUthB+R/xQEgLGkjfRPm7OcQRZwh6P3XQmuDc5IdK/mIIWprE8VI8Y2j8FieiH/MtvrgL38OEmf/b5srru41kRbzcfWTUheHFvlHqOr/EClHcj0myGCz8fskv0lnalZpHx7paV/U4xDllZoFPRiLQbWAqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l72TPJSrgoZMg3rvSAAEwz2h/E/CK9mZdYGcSSYVkQ=;
 b=JpP1Idq1GLHsndyVfw0s2A3GPXjqE+JTGnoiDrMkeU19bV4BtT11bSHaCL5uW5AiRjNnw0farheI++DdtsFVBwWAmdSvZvK33QA8TDEm+1j/Uy2KuOhnRdpsYZcDCB8xOfZ6dmHtXbmm3nSKKM9coMpe6maHpUAs1DiSMYp0N7EwmWno2r+iFGEfqOMMRosfIo2kiVyt/zVH/GPlY04laXhOWf10Ex6t44rG5S71SuWnOaqQ6WW43TeBJu5lg1MSl+U+lxBfK31vlKpoJ/aavGAPqunS91/iy+eJaJQVn7H0d+ttE3sp6ANoYg0xPsiFqHke2lS9ltueW5fhEqVZcA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 22:24:44 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 22:24:44 +0000
Date:   Wed, 25 Aug 2021 19:24:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH V4 10/13] PCI / VFIO: Add 'override_only' support for
 VFIO PCI sub system
Message-ID: <20210825222443.GN1721383@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
 <20210825135139.79034-11-yishaih@nvidia.com>
 <20210825160546.380c0137.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825160546.380c0137.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0015.prod.exchangelabs.com
 (2603:10b6:207:18::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR0102CA0015.prod.exchangelabs.com (2603:10b6:207:18::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 25 Aug 2021 22:24:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mJ1K7-0057JM-8k; Wed, 25 Aug 2021 19:24:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2597c476-297e-4cfa-3fb4-08d96817239e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5176D8C6D5CF7FAEBC381400C2C69@BL1PR12MB5176.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SaXYp3zAYL74nMZc/O8zdo/4F6V4PLQ/nEdDdvqnPB0iQQOTPXJKZO6WHJPYVgGRQCjHM0hXAdIJJHnAsjsD+D4hVoqHQXLUI0E1ia784v74qlnf/8Fhm45tuvKBmSJQ2jF2TvJ0VmVVYJgTtfmz1b86bfxXfO/dYUC6uc0GLjzzwa+nrVAkbHMiRo/aDJkJ/B6OuJ0Gqm+OTYEOdvodPpbOU977jvPojimSPRr9pHOeEgPWjXAOHaBXADCpMmaVtybHttNMXPsoTY8FXG155A0OFNB5t+89244ozPnxc+iPpbGz3zH98xBxdnmD9uDBhGt1RYamCHKtmf4st5rjWdKCkgBFKrD1++SRrfIBK+wxgAzKOIGvCgQfBWH0eEq12q4Le/sYZkqA3Fp5sP7IXFEiCYNwQBmTbjvocMMFoHiuchnEWJbRyfeqLNgD+5koNlswfR4SvMlo0/2ZNXMtj1NZP/urldnckDlwdSgZg06rGPurE6A4UnlWLBejXkrpsx+9DUFIRHeOkWGA9oqjq5zV8ur6p0UmGs61cHgtrDwNJ0X8QQBLE67iQGho7YWKt3l3LlQoddbY6aibBeq5k8BFNoekAZB9tfwluDyhVBiu9/wLs/H14cI5fvpOK6tAygU5fy2ZsQ60xIzH1OkmMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(36756003)(1076003)(107886003)(8676002)(7416002)(478600001)(8936002)(66556008)(26005)(186003)(5660300002)(33656002)(2616005)(316002)(2906002)(426003)(6916009)(4326008)(38100700002)(86362001)(9786002)(9746002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8kdg17Ja7vWRSg5mPMu/TDCOqL5+DJW+gOamvNXvOjcgOQqGyRNpWMU+2Mxh?=
 =?us-ascii?Q?bmRH6mwx7LIQ3zRkDVLEW6vMEF5jDpFNb3GTDaryS1/wMjpm5EsIgpX6opI0?=
 =?us-ascii?Q?3/M/VHrTaK3GUgO3mf/xE8NNjEH3AngETLlmbm+mfUqHH4CAuAFTcddMooEQ?=
 =?us-ascii?Q?hUoLpQvGfFmeh88pqPzqgXo1c7TPJJgefGw83+ZNkv59ryRKnxoRv6t+L8YX?=
 =?us-ascii?Q?aMEF8n6snOj1m7d+R7AgVB3KkPWuqb5+L+1g+DHEJyV67ibuy/2Q7Mk87kZq?=
 =?us-ascii?Q?hgcsOm8eHXjaFcH3x/j8UfJsnfycg3+oULdSS+JsqjXZkfzq8bzVJr3aaa7O?=
 =?us-ascii?Q?pBH13weQNR0qPJJNyQpHvUFaKMQBqzo1lKmi5q0puhG1k1fXD+YPb8ubWqDW?=
 =?us-ascii?Q?c70LhBLFXoB127BMxBWaw2g3fxnCoG/TvOdINd3/+wdFDnuB9aZaLtvh1GIh?=
 =?us-ascii?Q?y7rSUxgvJ54vdbDckI/yxDeSmusFM7Hmu2TMnndOW2gHfjqiWF8BcRbK2UhO?=
 =?us-ascii?Q?h54MkMKXvKHqWkJQKSevsz8ZlK/31rtBczSlSM3qV5NndCxpZgA/hpZclPem?=
 =?us-ascii?Q?hqNCYoI+z0ewktdF0uXYqfWFNtw3lV20FtPVvb69sFKhuA+SkMPfwA76qp4h?=
 =?us-ascii?Q?74XHK25tr1xLkQkZvnLPK9gmIk6FVDH+3oH4pyVpQ+LKxIUtJ4aq417trm9p?=
 =?us-ascii?Q?uvGsFUbPRmJYw2r6gloXcEHrf6jML64j8IJKPmlC5CBViiiQcgLyiLbmY86J?=
 =?us-ascii?Q?5z83FQ9KLEP/YQ5OesERCHg0c41+6Y3zwpqIyz1D5zis8VG5h2ka1oFuyBi7?=
 =?us-ascii?Q?nYYojvrOFr6C7pLMTT9ihRBTtc86ovJKdsTF6uY7O5ANr14Lb2Pw1gTxiHUS?=
 =?us-ascii?Q?fudqs9Es49VnVgKxf2NF6+L+KZVxPbjRaE/0+97XbQf6IG4oWiC2x7jqS5mv?=
 =?us-ascii?Q?zucsg3wUdIUQwE71QVbk5IyKFLEx7eZ2BrxwzVQje0qwC+UBe0pP6vPLDXxB?=
 =?us-ascii?Q?MefP0xgR7aLlT8gb/HfIGOmsoU6Df9Soln0uKUr0TvGgf/EezuFLfJJiejBZ?=
 =?us-ascii?Q?50qP0QqznxJcOqU8X1zJ3u9mgFWun2to0tL9/+mXzVrSGcxLb01+aXgGGyyM?=
 =?us-ascii?Q?A9+RET44Y3KjeOAAQ/FOOWtSxkOPWWKQtPQm0fsAWNuB781PsPhrwVHiJKyl?=
 =?us-ascii?Q?q7epWoiRkihkyd6G9fyBRpLjn38N1EZ5i83ZKYBrajENUb1SCZrsGpmG7qm9?=
 =?us-ascii?Q?KHQnWNwe7pJIHiXHpQhGbikVXh5wSS5NCPtZpTfGL13lvjZGcl2jhWLLf52D?=
 =?us-ascii?Q?i5WiGv1W8NaoXaVMlHXOwZj4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2597c476-297e-4cfa-3fb4-08d96817239e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 22:24:44.2368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8pc5UpLGvshebq59YXHigOcoN5xS32oKk0ZNh0AeQTZVoqdslHI1NkWEOrIGTPJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5176
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:05:46PM -0600, Alex Williamson wrote:
> On Wed, 25 Aug 2021 16:51:36 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> > index 7c97fa8e36bc..c3edbf73157e 100644
> > +++ b/scripts/mod/file2alias.c
> > @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
> >  	return 1;
> >  }
> >  
> > -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
> > +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
> >  static int do_pci_entry(const char *filename,
> >  			void *symval, char *alias)
> >  {
> > @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
> >  	DEF_FIELD(symval, pci_device_id, subdevice);
> >  	DEF_FIELD(symval, pci_device_id, class);
> >  	DEF_FIELD(symval, pci_device_id, class_mask);
> > +	DEF_FIELD(symval, pci_device_id, override_only);
> >  
> > -	strcpy(alias, "pci:");
> > +	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> > +		strcpy(alias, "vfio_pci:");
> > +	else
> > +		strcpy(alias, "pci:");
> 
> I'm a little concerned that we're allowing unknown, non-zero
> override_only values to fall through to create "pci:" alias matches.
> Should this be something like:
> 
> 	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE) {

Should probably be == not &, since in this new arrangement it is
really more of an enum than a bit flags... A switch would be OK here
too

> 		strcpy(alias, "vfio_pci:");
> 	} else if (override_only) {
> 		warn("Unknown PCI driver_override alias %08X\n",
> 			driver_override);
> 		return 0;
> 	} else {
> 		strcpy(alias, "pci:");
> 	}

It seems reasonable to me to throw a warn, it signals to a future
developer that kbuild is not working right.

> And then if we can only have a single bit set in override_only (I
> can't think of a use case for a single entry to have multiple
> override options), should PCI_DEVICE_DRIVER_OVERRIDE() be defined to
> take a "driver_override_shift" value where .driver_override is assigned
> (1 << driver_override_shift)?  That would encode the semantics in the
> prototypes a little better.  

I think it is just an enum of overrides, no reason to make it one hot
encoded. Previously when it was flags the bit encode had a certain
amount of logic, but no longer.

Jason
