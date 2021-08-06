Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94543E1FF7
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 02:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbhHFAYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 20:24:15 -0400
Received: from mail-bn8nam11on2076.outbound.protection.outlook.com ([40.107.236.76]:45330
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238757AbhHFAYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 20:24:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+OxaedSECgah2q7EceiDmitsaCBghWVUdi6iyXjkFTvwrpiLmjye+4gBZlbl+sUJAJq8BIJvVfifkt0ymzY5Ht0BggH0Sjhw92IHLuPSv0JdJuTo+pXqokqYs6rK85ukEe7E0PRMdCaVg42IXjQHJfpi8CFRNM907QDV+VcXwlQkdH/qgbawNyMqfL+Y4EQniYAlTJYind5zYj5I1hixWjqL0NNFixNfuqboHAb9oGQqIGZg812EeWLW6rBf0Mf3pFNm9+QKRQUMu8pR/80P0hAzxOyXrDOCGdtpGEV+HLUVLOIhzvvEm+EhZy9dnu8f/UPHdw1JNIlWwD6XF2OUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4VWPshiCn8S4pFe6Sz8RiKzdQdXieO2aMLSmrOVkwA=;
 b=VJyoR5aHvvbXXi2qcYx/NX5iTctmKZqggF+9In3FUu/zL7JbAC+ZUye/7AT9xPvFPyCd2VXDUGeXRNpoauBZIfgur7DtR5acSKgrHEdSytDkQqW75vbpPEJYNcx/W59txFNd3nDtP7bnXDs3b3If0UAhFVQrVxceCdkwH3PuiDeL6V9R7jQVvCv2BBuhEZGyJw/UgdUqYSeTmHPjgO3g2sqC83k60jMJnCwRVE07+W8C9OxlfH1BguaEqhrJuKRU/NanQW03dRvGKOnGZXsiIcigDLg1f4mxptcBRrpELT+KQ0RF2wRJ8Zm86/8SuYB9Vd6yojCKCl9VJP1Oy5Emuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4VWPshiCn8S4pFe6Sz8RiKzdQdXieO2aMLSmrOVkwA=;
 b=BRf/liJ3fnnxD5Y+ZqShev31eeTclfIO+hZiKVT7sbPtYhO0dsuv2SeS4Xm9pOkKs4794tuRD73d9NAQ28kkOxErxO21SNHnOwWPJwMDDCH+bRWhNu0EcNkDu1qQNpNC9aJMKamXdXMATrILOy8pQk0BkCAjYA2oiC8VvjCEjZElilDZGQcDgxHsHzi9mFePxVzfwKo04TUmN1GZAeKsnsxw4eFefCRZVwVPRNf8PHIUCxVY04d1Ugb9KHs6h3ZCxEH8lLGIIZBzhVN9OzCMBawx4EdtTKFtl2HjuYbPHOzVuvsM3yjPJeNhNriSLmDaFPXlIQSt7ZyCewVNLupokA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 00:23:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 00:23:58 +0000
Date:   Thu, 5 Aug 2021 21:23:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210806002357.GD1672295@nvidia.com>
References: <20210721161609.68223-10-yishaih@nvidia.com>
 <20210804203412.GA1663387@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804203412.GA1663387@bjorn-Precision-5520>
X-ClientProxiedBy: MN2PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:236::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0045.namprd05.prod.outlook.com (2603:10b6:208:236::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Fri, 6 Aug 2021 00:23:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mBneX-00DnEX-8e; Thu, 05 Aug 2021 21:23:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 130fec76-f7ee-49a2-36b1-08d958707b7b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5110D74C73C1813C1190A2D3C2F39@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztC41JSQggx1eGXCo69wlagE7FC9yhrycrzMgryedV1EXoLpOKbZyvhLxpzcfNwzNtO2MMX2u9AVB1yZuzbvSTFmAfSRVKbP9Q1TeXlOC4Gy71KePrZ9kpdvo8lwhWHJtkrKx9A+yrGmQph4Un6lG+0GdYRnRhy1cQhgod7K+WW+/04xBstCmV4hwAYQ/tNbbnoAKrEgERiObTGTe3jehzyCEbSfLGa+/mj2KVjo6PJ8uwa93WMRXJ/3NUzKoCynUOw25PJagpGGqtSMvPeoIszAMpBfh03H0deUZ6dbqSGh0jiHVmmHgkXioj0sFKKnuOQ4EeIH0SQeSV2pu6lwiEEFdKwG90QSfb0FSC9DAs0AFHXBR7mggDzfHTkPdc3I4VdB7a1nPeSPfMDg+QglxDBZNH2YEkwMCjpCsWter1JC/8d6+wml2LKRO2nFAnBB7CKdES+r+ga3I7d1fnd3m50bf7nYjQZ6nnF71pZ7+CojzXol0qor3ltYH3ggn2M4iBySr6l8TnM+LFkA3fs2NU9p/i35bhqndqtAal+JpHBeB2FRs2ZmuWbPgHEvQXP7KcUceDZB5MLmvUIqVB4OB350ht0oE+1N30/DzBNTIslSQHE0bc/Qt4dT42SYRjwBvt/EANsmobOmHM1IqQ3UOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(86362001)(83380400001)(26005)(2906002)(2616005)(33656002)(38100700002)(107886003)(6916009)(7416002)(4326008)(5660300002)(186003)(316002)(36756003)(66946007)(9786002)(9746002)(66556008)(66476007)(8936002)(1076003)(478600001)(8676002)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVbRaOoESygPfoFS9/fraQL//aKYi187cMcdB7WCrshb/pzkdrp44apSJkip?=
 =?us-ascii?Q?xZ4MAzSP2RkoEroV55bg5TJHRKfumHT0PagcbKPtnqc7kp5aMFHjQnHO3zFL?=
 =?us-ascii?Q?ZLFD7dgdYIPaVIcsRV/S8qRh/txDHFTJO6PL590tAojCRXJ57TMqizdv677+?=
 =?us-ascii?Q?dttcXc77Yau++mJBBMeipA/GWoep634bHgl7fn5a6jYJh/My8mbvzzlRmwoD?=
 =?us-ascii?Q?7iY+T5VFxTFm9TJr9iXyLdZe4TJM86d2rrZFCQJn9Jt3/TnydzxwlNRhn+py?=
 =?us-ascii?Q?6pJl7+wEpfjTvl6yqBWTn7aaApCTJc5V+RDW7mlsF1p/hP/oOZ2C8FQ4P7bL?=
 =?us-ascii?Q?GvpDbQzvnq0y1xK/6zGpGsLHxk8yCRcoDIEtjGpKa/IMJZ2eJk7MKi10mTiy?=
 =?us-ascii?Q?QdUnLJJMaoAEVBJc0AGT2/2MLnT6LCS5jN194/SRkKgiqFjMMnvJ17ulM+Ij?=
 =?us-ascii?Q?gcnUcILUBShTR+McPmiuy72RquLDI2fDg3ssFC6xGYGgQakZujBaU/wyO5Vz?=
 =?us-ascii?Q?rxWotDWV9gdfH0WRhdxYGuqEJzP92X1oZSSfmH4utxsA3cJWIQQ0DC9QVODL?=
 =?us-ascii?Q?s2h2XiIBivY4RLGgqPG0moLpTmjE3Lo9qn+6UpvJbTdOw+khwJWY/RBiFeRj?=
 =?us-ascii?Q?BK2MhPta6uWnKXh5e102/ViUskSdcB7TTWewJrbPibAwrqyL6LxJg7JJATPp?=
 =?us-ascii?Q?1CVLTnCP1kx1RWIbTpxMncITLeERvmJnk2eSS/I90WKiwWuiOldZZpV8mHIr?=
 =?us-ascii?Q?X9KLhof+HAJxiy9H4Ab7AYuiyXcF3NCDlggxS6w7w1q5+1yNPmhAfRPJ2It+?=
 =?us-ascii?Q?iIw4nwV8FdMoplGo//+XtSGVfiMGM/L0oPU5h4f4dklgsJn1VDteeiVWfuLP?=
 =?us-ascii?Q?MzOihn9YAm5f5NzVil0caoCOizkI7TANxTDsT/Lt6NQ4YfteOkCkOE3ULq1g?=
 =?us-ascii?Q?fr588Az0zEXgUCPoS8mlYY1t8qLBHwenU+ywXxUOodMG7RT5xYamnJcBn++m?=
 =?us-ascii?Q?VMtVuVVlr2xAIrL0qPtyxMKs9SpTYDt+oBtBL38LHg3mlKSSaInJ1PuQlbm0?=
 =?us-ascii?Q?I6rXp4uEJQ+T1Nz81rGt+Jf/rI/l+nPvuPMdUuip+uLRmsTeFZ6bH7S+8Zno?=
 =?us-ascii?Q?T8eRO/j9uzCMhysxNo7XLTy86ojy2hiICupXFdOYF51Cxw9XjSNo1NuvQHum?=
 =?us-ascii?Q?C3Dq6o3g+BduXdM64DaM7MRModXotfuY7YxDJVUezQwwyyQwmDS3NKcHq7dh?=
 =?us-ascii?Q?PdQiH2udePorTOuCKsWGF2OITf5JxWg38FleSxhmKOJpxw3sDrnHCpnq1jtO?=
 =?us-ascii?Q?JB6BqnCF/1eEeUMmEH3hDSg1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130fec76-f7ee-49a2-36b1-08d958707b7b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:23:58.2960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+9k0M/xdrOcgg1ASygUMwl1W3icwzB1MnOfymnWJhuZ50IqlI5Q5TluOimrlwyi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 03:34:12PM -0500, Bjorn Helgaas wrote:

> > The first use will be to define a VFIO flag that indicates the PCI driver
> > is a VFIO driver.
>
> Is there such a thing as a "VFIO driver" today?  

Yes.

VFIO has long existed as a driver subsystem that binds drivers to
devices in various bus types. In the case of PCI the admin moves a PCI
device from normal operation to VFIO operation via something like:

echo vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override

Other bus types (platform, acpi, etc) have a similar command to move
them to VFIO.

> > VFIO drivers have a few special properties compared to normal PCI drivers:
> >  - They do not automatically bind. VFIO drivers are used to swap out the
> >    normal driver for a device and convert the PCI device to the VFIO
> >    subsystem.
> 
> The comment below says "... any matching PCI_ID_F_DRIVER_OVERRIDE
> [sic] entry is returned," which sounds like the opposite of "do not
> automatically bind."  Might be exposing my VFIO ignorance here.

The comment is in error
 
> >    The admin must make this choice and following the current uAPI this is
> >    usually done by using the driver_override sysfs.
> 
> I'm not sure "converting PCI device to the VFIO subsystem" is the
> right way to phrase this, but whatever it is, make this idea specific,
> e.g., by "echo pci-stub > /sys/.../driver_override" or whatever.

The next version will include the sequence we worked out with Alex in
the other branch of this thread. See below

> >  - The modules.alias includes the IDs of the VFIO PCI drivers, prefixing
> >    them with 'vfio_pci:' instead of the normal 'pci:'.
> > 
> >    This allows the userspace machinery that switches devices to VFIO to
> >    know what kernel drivers support what devices and allows it to trigger
> >    the proper device_override.
> 
> What does "switch device to VFIO" mean?  I could be reading this too
> literally (in my defense, I'm not a VFIO expert), but AFAICT this is
> not something you do to the *device*.  

It means change the struct device_driver bound to the struct device -
which is an operation that the admin does on the device object.

> I guess maybe this is something like "prevent the normal driver from
> claiming the device so we can use VFIO instead"?

no..

> Does "using VFIO" mean getting vfio-pci to claim the device?

If by claim you mean bind a pci_driver to the pci_dev, then yes.

> > As existing tools do not recognize the "vfio_pci:" mod-alias prefix this
> > keeps todays behavior the same. VFIO remains on the side, is never
> > autoloaded and can only be activated by direct admin action.
> 
> s/todays/today's/
> 
> > This patch is the infrastructure to provide the information in the
> > modules.alias to userspace and enable the only PCI VFIO driver. Later
> > series introduce additional HW specific VFIO PCI drivers.
> 
> s/the only/only the/ ?  (Not sure what you intend, but "the only"
> doesn't seem right)

"the only" is correct, at this point in the sequence there is only one
pci_driver that uses this, vfio_pci.ko

> Sorry, I know I'm totally missing the point here.

Lets try again..

PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id

Allow device drivers to include match entries in the modules.alias file
produced by kbuild that are not used for normal driver autoprobing and
module autoloading. Drivers using these match entries can be connected to
the PCI device manually, by userspace, using the existing driver_override
sysfs.

Add the flag PCI_ID_F_VFIO_DRIVER_OVERRIDE to indicate that the match
entry is for the VFIO subsystem. These match entries are prefixed with
"vfio_" in the modules.alias.

For example the resulting modules.alias may have:

  alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
  alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

In this example mlx5_core and mlx5_vfio_pci match to the same PCI
device. The kernel will autoload and autobind to mlx5_core but the kernel
and udev mechanisms will ignore mlx5_vfio_pci.

When userspace wants to change a device to the VFIO subsystem userspace
can implement a generic algorithm:

   1) Identify the sysfs path to the device:
    /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0

   2) Get the modalias string from the kernel:
    $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
    pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

   3) Prefix it with vfio_:
    vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

   4) Search modules.alias for the above string and select the entry that
      has the fewest *'s:
    alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci

   5) modprobe the matched module name:
    $ modprobe mlx5_vfio_pci

   6) cat the matched module name to driver_override:
    echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override

The algorithm is independent of bus type. In future the other buses's with
VFIO device drivers, like platform and ACPI, can use this algorithm as
well.

This patch is the infrastructure to provide the information in the
modules.alias to userspace. Convert the only VFIO pci_driver which
results in one new line in the modules.alias:

  alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci

Later series introduce additional HW specific VFIO PCI drivers, such as
mlx5_vfio_pci.

> > diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> > index 7c97fa8e36bc..f53b38e8f696 100644
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
> > +	DEF_FIELD(symval, pci_device_id, flags);
> 
> I'm a little bit wary of adding a new field to this kernel/user
> interface just for this single bit.  Maybe it's justified but feels
> like it's worth being careful.

A couple of us looked at this in one of the RFC threads..

As far as we could tell this is not a kernel/user interface. It is an
interface within kbuild between gcc and file2alias and is not used or
really exported beyond the kernel build sequence.

Debian code search didn't find anything, for instance.

modules.alias, as output by file2alias during kbuild, is the canonical
"kernel/user" interface here. Everything that needs this data should
be using that.

Thanks,
Jason
